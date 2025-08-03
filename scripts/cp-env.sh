#!/usr/bin/env bash
# This script copies all .env.example files to .env in their respective directories.
find . -type f -name ".env.example" -execdir cp -- "{}" ".env" \;