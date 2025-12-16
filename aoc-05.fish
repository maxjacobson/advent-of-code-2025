function range_covers
    set --local range (string split "-" $argv[1])
    set --local id $argv[2]

    test "$id" -ge $range[1] -a "$id" -le $range[2]
end

function fully_less_than
    set --local range_one (string split "-" $argv[1])
    set --local range_two (string split "-" $argv[2])

    test "$range_one[1]" -lt "$range_two[1]" -a "$range_one[2]" -lt "$range_two[1]"
end

function fully_greater_than
    set --local range_one (string split "-" $argv[1])
    set --local range_two (string split "-" $argv[2])

    test "$range_one[1]" -gt "$range_two[2]" -a "$range_one[2]" -gt "$range_two[2]"
end

function range_overlaps
    if fully_less_than $argv
        false
    else if fully_greater_than $argv
        false
    else
        true
    end
end

function merge_these_two_ranges_please
    set --local range_one (string split "-" $argv[1])
    set --local range_two (string split "-" $argv[2])
    set --local min
    set --local max

    if test $range_one[1] -lt $range_two[1]
        set min $range_one[1]
    else
        set min $range_two[1]
    end

    if test $range_one[2] -gt $range_two[2]
        set max $range_one[2]
    else
        set max $range_two[2]
    end

    echo "$min-$max"
end

function merge_overlapping_ranges
    set --local ranges $argv
    set --local merged_ranges

    for range in $ranges
        set --local merged_ranges_count (count $merged_ranges)
        set --local did_merge nope

        if test "$merged_ranges_count" -gt 0
            for idx in (seq 1 $merged_ranges_count)
                set --local merged_range $merged_ranges[$idx]

                if range_overlaps "$range" "$merged_range"
                    set merged_ranges[$idx] (merge_these_two_ranges_please "$range" "$merged_range")
                    set did_merge yep
                    break
                end
            end
        end

        if test "$did_merge" = nope
            set --append merged_ranges "$range"
        end
    end

    set --local merged_ranges_count (count $merged_ranges)
    set --local ranges_count (count $ranges)

    if test "$merged_ranges_count" -eq "$ranges_count"
        string split " " $merged_ranges
    else
        merge_overlapping_ranges $merged_ranges
    end
end

function main
    set --local part_one_result 0
    set --local part_two_result 0
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

    for merged_range in (merge_overlapping_ranges $fresh_ingredient_id_ranges)
        set --local range (string split "-" $merged_range)
        set --local delta (math "$range[2] - $range[1] + 1")
        set part_two_result (math --scale=0 "$part_two_result + $delta")
    end

    echo "Part one: $part_one_result"
    echo "Part two: $part_two_result"
end

main $argv[1]
