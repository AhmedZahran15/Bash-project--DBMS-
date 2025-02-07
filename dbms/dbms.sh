#!/bin/bash
DB_DIR="databases"
CURRENT_DB=""
export DB_DIR CURRENT_DB

for file in ./lib/*.sh; do
    source "$file"
done

mkdir -p "$DB_DIR"
main_menu
