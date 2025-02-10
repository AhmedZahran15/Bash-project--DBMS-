display_table() {
   
}


list_tables() {
    echo "Available Tables:"
    ls "$DB_DIR/$CURRENT_DB" | grep ".metadata$" | sed 's/.metadata$//' | awk '{print NR".", $0}'
}