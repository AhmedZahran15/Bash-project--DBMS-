validate_identifier() {
    local name="$1"
    if [[ ! $name =~ ^[a-zA-Z_][a-zA-Z0-9_]{0,63}$ ]]; then
        echo "Invalid name! Must start with letter/underscore, followed by alphanumerics."
        return 1
    elif is_reserved_keyword "$name"; then
        echo "Invalid name! '$name' is a reserved keyword."
        return 1
    fi
    return 0
}

removeQuotes() {
    # Read input with trailing spaces and quotes
    # Remove surrounding quotes (either "..." or '...')
    local input="$1"
    if [[ "$input" =~ ^\"(.*)\"$ ]]; then
        input="${BASH_REMATCH[1]}"
    elif [[ "$input" =~ ^\'(.*)\'$ ]]; then
        input="${BASH_REMATCH[1]}"
    fi
    echo "$input"
}

validate_column_def() {
    [[ $1 =~ ^[a-zA-Z_]+\ +(int|string|date)(\ +primary)?$ ]] || return 1
}

validate_data_type() {
    local value="$1" dtype="$2"
    case "$dtype" in
        int) [[ "$value" =~ ^-?[0-9]+$ ]] ;;
        date) [[ "$value" =~ ^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])$ ]] ;;
        string) true ;;  # Accept any string
        *) return 1 ;;
    esac
}

is_reserved_keyword() {
    local name="$1"
    grep -qixF "$name" ./lib/reserved_keywords.txt
}

check_pk_exists() {
    local tblname="$1" pk_value="$2"
    local metadata="$DB_DIR/$CURRENT_DB/$tblname.metadata"
    local datafile="$DB_DIR/$CURRENT_DB/$tblname.data"
    
    # Find primary key column index
    local pk_col=$(awk '/primary/ {print NR}' "$metadata")
    [[ -z $pk_col ]] && return 1
    
    # Check if value exists
    awk -F: -v col="$pk_col" -v val="$pk_value" '$col == val {found=1; exit} END {exit !found}' "$datafile"
}
