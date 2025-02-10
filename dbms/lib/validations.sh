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
    local input="$1"
    if [[ "$input" =~ ^\"(.*)\"$ ]]; then
        input="${BASH_REMATCH[1]}"
    elif [[ "$input" =~ ^\'(.*)\'$ ]]; then
        input="${BASH_REMATCH[1]}"
    fi
    echo "$input"
}

validate_column_def() {
    if [[ $1 =~ ^[a-z_]+[[:space:]]+(int|string|date|float)([[:space:]]+primary)?$ ]]; then
        return 0
    fi
    return 1
}

validate_data_type() {
    local value="$1" dtype="$2"
    case "$dtype" in
    int) if [[ "$value" =~ ^-?[0-9]+$ ]]; then
        return 0
    fi ;;
    date) if [[ "$value" =~ ^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])$ ]]; then return 0; fi ;;
    string) return 0 ;;
    float) if [[ "$value" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; then
        return 0
    fi ;;
    *) return 1 ;;
    esac
}

is_reserved_keyword() {
    local name="$1"
    grep -qixF "$name" ./lib/reserved_keywords.txt
}

check_pk_exists() {
    local tblname="$1" pk_value="$2" pk_index="$3"
    local metadata="$DB_DIR/$CURRENT_DB/$tblname.metadata"
    local datafile="$DB_DIR/$CURRENT_DB/$tblname.data"
    res=$(awk -v pk_index="$pk_index" -v pk_value="$pk_value" -F',' '$pk_index == pk_value' "$datafile")
    if [[ -z $res ]]; then
        return 1
    fi
    return 0
}
