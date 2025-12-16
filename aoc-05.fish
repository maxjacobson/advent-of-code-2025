function range_covers
    set --local range (string split "-" $argv[1])
    set --local id $argv[2]

    test "$id" -ge $range[1] -a "$id" -le $range[2]
end

function main
    set --local part_one_result 0
    set --local fresh_ingredient_id_ranges
    set --local available_ingredient_ids
    set --local encountered_blank_line nope

    cat "$argv[1]" | while read line
        if test "$line" = ""
            set encountered_blank_line yep
        else if test "$encountered_blank_line" = nope
            set --append fresh_ingredient_id_ranges "$line"
        else
            set --append available_ingredient_ids "$line"
        end
    end

    for id in $available_ingredient_ids
        for range in $fresh_ingredient_id_ranges
            if range_covers "$range" "$id"
                set part_one_result (math "$part_one_result + 1")
                break
            end
        end
    end

    echo "Part one: $part_one_result"
end

main $argv[1]
