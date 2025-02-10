create_db() {
    read -ep "Enter database name: " dbname
    dbname=$(removeQuotes "$dbname")
    if ! validate_identifier "$dbname"; then return; fi
    
    if [[ -d "$DB_DIR/$dbname" ]]; then
        echo "Database '$dbname' already exists!"
    else
        mkdir -p "$DB_DIR/$dbname"
        echo "Database '$dbname' created."
    fi
}

list_dbs() {
    if [[ `ls -1 "$DB_DIR" | wc -l` == 0 ]]; then
        echo "No databases found!"
        return
    fi
    echo "Available Databases:"
    ls -1 "$DB_DIR" | awk '{print NR".", $0}'
}

connect_db() {
    read -ep "Enter database name: " dbname
    if [[ -d "$DB_DIR/$dbname" ]]; then
        CURRENT_DB="$dbname"
        table_menu
    else
        echo "Database '$dbname' does not exist!"
    fi
}

drop_db() {
    read -ep "Enter database name to drop: " dbname
    if [[ -d "$DB_DIR/$dbname" ]]; then
        rm -r "$DB_DIR/$dbname"
        echo "Database '$dbname' dropped."
    else
        echo "Database '$dbname' not found!"
    fi
}