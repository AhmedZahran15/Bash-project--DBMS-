table_menu() {
    while true; do
        clear
        echo "==================== Table Menu ($CURRENT_DB) ===================="
        PS3=">> Choose an operation: "
        options=("Create Table" "List Tables" "Drop Table" "Insert Row" "Select Table" "Delete Row" "Update Row" "Back")
        
        select opt in "${options[@]}"; do
            case $REPLY in
                1) create_table; break ;;
                2) list_tables; break ;;
                3) drop_table; break ;;
                4) insert_row; break ;;
                5) select_from_table; break ;;
                6) delete_from_table; break ;;
                7) update_table; break ;;
                8) return;;
                *) echo "Invalid option!"; break ;;
            esac
        done
        echo
        read -p "Press Enter to continue..."
    done
}