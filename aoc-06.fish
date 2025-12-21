function count_columns
    set --local lines (string split " " $argv[1])
    set --local first_line $lines[1]

    count (string split "," $first_line)
end

function extract_part
    set --local line $argv[1]
    set --local column $argv[2]
    set --local parts (string split "," "$line")

    echo $parts[$column]
end

function extract_columns
    set --local lines (string split " " $argv[1])
    set --local column 1
    set --local columns_count (count_columns "$lines")

    while test "$column" -le "$columns_count"
        set --local parts
        for line in $lines
            set --local part (extract_part "$line" "$column")
            set --append parts $part
        end

        echo $parts
        set column (math "$column + 1")
    end
end

function column_to_math_expression
    set --local column $argv[1]
    set --local parts (string split " " "$column")
    set --local operator $parts[-1]
    set --local numbers $parts[1..-2]

    string join " $operator " $numbers
end

function main
    set --local part_one_result 0
    while read --line line
        set line (string trim "$line")

        set --append lines (string replace --all --regex "\s+" "," "$line")
    end

    for column in (extract_columns "$lines")
        set --local expression (column_to_math_expression "$column")
        set --local expression_result (math "$expression")
        set part_one_result (math --scale=0 "$part_one_result + $expression_result")
    end

    echo "Part one: $part_one_result"
end

main
