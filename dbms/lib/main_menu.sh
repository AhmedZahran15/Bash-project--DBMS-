main_menu() {
    while true; do
        clear
        echo "==================== Main Menu ===================="
        PS3=">> Choose an option: "
        options=("Create Database" "List Databases" "Connect to Database" "Drop Database" "Exit")
        echo "${options[@]}"
        select opt in "${options[@]}"; do
            case $REPLY in
                1) create_db; break ;;
                2) list_dbs; break ;;
                3) connect_db; break ;;
                4) drop_db; break ;;
                5) exit 0 ;;
                *) echo "Invalid option!"; break ;;
            esac
        done
        echo
        read -p "Press Enter to continue..."
    done
}
