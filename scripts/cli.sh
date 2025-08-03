#!/usr/bin/env bash
# Usage: ./cli.sh [action] [services...]
# Available actions:
#   up/start – start all services (default) or specific services
#   down     – stop all services or specific services, keep named volumes
#   restart  – restart services (preserving volumes, removing containers only)
#   rm       – stop and remove containers, networks and anonymous volumes
#   list     – list all available services
#   status   – show status of all containers
#
# Examples:
#   ./cli.sh                     # Start all services
#   ./cli.sh start postgres      # Start postgres service
#   ./cli.sh restart postgres    # Restart postgres (keeping volumes)
#   ./cli.sh up ollama grafana   # Start ollama and grafana services
#   ./cli.sh list                # List all available services
#   ./cli.sh status              # Show container status

set -euo pipefail
shopt -s globstar nullglob   # enable ** recursive globbing

# ------------ functions ------------
get_all_services() {
  local services=()
  for compose in **/docker-compose.yml; do
    dir=$(dirname "$compose")
    services+=("$dir")
  done
  printf '%s\n' "${services[@]}"
}

list_services() {
  echo "📋 Available services:"
  echo ""
  for compose in **/docker-compose.yml; do
    dir=$(dirname "$compose")
    echo "   $dir"
  done
}

show_status() {
  echo "📊 Container Status:"
  echo ""
  
  # Check if there are any containers
  if ! docker ps -a --quiet | head -1 | read -r; then
    echo "ℹ️  No containers found"
    return
  fi
  
  # Show containers with proper formatting
  docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
}

resolve_conflicts() {
  local service_path="$1"
  local preserve_volumes="${2:-false}"
  
  echo "🔧 Checking for container conflicts in $service_path..."
  
  # Get container names from docker-compose.yml
  local container_names
  container_names=$(cd "$service_path" && docker compose config --services 2>/dev/null)
  
  if [[ -n "$container_names" ]]; then
    while IFS= read -r service_name; do
      # Check if container exists (running or stopped)
      local existing_container
      existing_container=$(docker ps -aq --filter "name=${service_name}" 2>/dev/null)
      
      if [[ -n "$existing_container" ]]; then
        echo "🔄 Found existing container for service '$service_name', removing..."
        docker rm -f "$existing_container" 2>/dev/null || true
      fi
    done <<< "$container_names"
  fi
  
  # Clean up dangling resources, but preserve volumes if requested
  if [[ "$preserve_volumes" == "true" ]]; then
    echo "🧹 Cleaning up dangling resources (preserving volumes)..."
    docker system prune -f 2>/dev/null || true
  else
    echo "🧹 Cleaning up dangling resources..."
    docker system prune -f --volumes 2>/dev/null || true
  fi
}

run_compose() {
  local action="$1"
  shift
  local services=("$@")
  
  # If no services specified, run on all
  if [[ ${#services[@]} -eq 0 ]]; then
    mapfile -t services < <(get_all_services)
  fi
  
  for service_path in "${services[@]}"; do
    if [[ -f "$service_path/docker-compose.yml" ]]; then
      printf "\n▶ %s in %s\n" "$action" "$service_path"
      
      # Resolve conflicts before starting services
      if [[ "$action" == "up" || "$action" == "start" ]]; then
        resolve_conflicts "$service_path" "false"
      elif [[ "$action" == "restart" ]]; then
        resolve_conflicts "$service_path" "true"
      fi
      
      (
        cd "$service_path"
        case "$action" in
          up|start) 
            echo "🚀 Starting services..."
            docker compose up -d --build
            ;;
          down|stop) 
            echo "🛑 Stopping services..."
            docker compose down 
            ;;
          restart)
            echo "🔄 Restarting services (preserving volumes)..."
            docker compose down
            docker compose up -d --build
            ;;
          rm) 
            echo "🗑️  Removing services with volumes..."
            docker compose down --volumes --remove-orphans 
            ;;
        esac
      )
      
      # Show status after action
      if [[ "$action" == "up" || "$action" == "start" || "$action" == "restart" ]]; then
        echo "✅ Service status:"
        (cd "$service_path" && docker compose ps)
      fi
    else
      echo "⚠️  Service '$service_path' not found (no docker-compose.yml)"
    fi
  done
}

# ------------ dispatcher ------------
action="${1:-up}"
shift 2>/dev/null || true  # Remove first argument, ignore error if no args

case "$action" in
  up|start)
    if [[ $# -eq 0 ]]; then
      echo "🚀 Starting all services..."
      run_compose "up"
    else
      echo "🚀 Starting specified services..."
      run_compose "up" "$@"
    fi
    ;;
  down|stop)
    if [[ $# -eq 0 ]]; then
      echo "🛑 Stopping all services..."
      run_compose "down"
    else
      echo "🛑 Stopping specified services..."
      run_compose "down" "$@"
    fi
    ;;
  restart)
    if [[ $# -eq 0 ]]; then
      echo "🔄 Restarting all services (preserving volumes)..."
      run_compose "restart"
    else
      echo "🔄 Restarting specified services (preserving volumes)..."
      run_compose "restart" "$@"
    fi
    ;;
  rm)
    if [[ $# -eq 0 ]]; then
      echo "🗑️  Removing all services (including volumes)..."
      run_compose "rm"
    else
      echo "🗑️  Removing specified services (including volumes)..."  
      run_compose "rm" "$@"
    fi
    ;;
  list)
    list_services
    ;;
  status)
    show_status
    ;;
  help|--help|-h)
    echo "🏠 Self-Hosted Infrastructure Management Script"
    echo ""
    echo "Usage: $0 [action] [services...]"
    echo ""
    echo "Available actions:"
    echo "  up/start [services...]  – start all or specific services"
    echo "  down/stop [services...] – stop all or specific services"
    echo "  restart [services...]   – restart services (preserving volumes)"
    echo "  rm [services...]        – remove all or specific services (with volumes)"
    echo "  list                    – list available services"
    echo "  status                  – show container status"
    echo "  help                    – show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                      # Start all services"
    echo "  $0 start postgres       # Start postgres service"
    echo "  $0 restart postgres     # Restart postgres (keeping volumes)"
    echo "  $0 up llms/ollama       # Start ollama service"
    echo "  $0 down homarr postgress # Stop specific services"
    echo "  $0 list                 # List all services"
    echo "  $0 status               # Show status"
    ;;
  *)
    echo "❌ Unknown action: $action"
    echo ""
    echo "Usage: $0 [action] [services...]"
    echo ""
    echo "Available actions:"
    echo "  up/start [services...]  – start all or specific services"
    echo "  down/stop [services...] – stop all or specific services"
    echo "  restart [services...]   – restart services (preserving volumes)"
    echo "  rm [services...]        – remove all or specific services (with volumes)"
    echo "  list                    – list available services"
    echo "  status                  – show container status"
    echo ""
    echo "Examples:"
    echo "  $0 start postgres       # Start postgres service"
    echo "  $0 restart postgres     # Restart postgres (keeping volumes)"
    echo "  $0 up llms/ollama       # Start ollama service"
    echo "  $0 list                 # List all services"
    echo "  $0 status               # Show status"
    exit 1
    ;;
esac
