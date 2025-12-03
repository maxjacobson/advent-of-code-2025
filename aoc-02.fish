set --local input (cat $argv[1])
set --local ranges (string split , "$input")
set --local part_one_result 0
set --local part_two_result 0

function id_invalid_part_one
    set --local id $argv[1]
    set --local length (string length $id)

    if test (math "$length % 2") -eq 0
        set --local length (string length $id)
        set --local half_way_point (math "$length / 2")
        set --local first_half (string sub --length "$half_way_point" $id)
        set --local second_half (string sub --start "-$half_way_point" $id)

        test "$first_half" -eq "$second_half"
    else
        false
    end
end

function invalid_part_one_ids
    set --local id $argv[1]
    set --local stop $argv[2]

    while test $id -le $stop
        if id_invalid_part_one "$id"
            echo "$id"
        end

        set id (math "$id + 1")
    end
end

function factors_for
    set --local num $argv[1]

    for n in (seq 1 $num)
        set --local x (math "$num % $n")
        if test $x -eq 0
            if test $n -ne $num
                echo $n
            end
        end
    end
end

function candidates_for
    set --local candidate_length $argv[1]
    set --local substring_length $argv[2]
    set --local repetitions (math "$candidate_length / $substring_length")
    set --local ceil (string repeat "9" -n "$substring_length")

    for n in (seq 1 $ceil)
        string repeat $n -n $repetitions
    end
end

function invalid_part_two_ids
    set --local start $argv[1]
    set --local stop $argv[2]

    set --local start_digits (string length $start)
    set --local stop_digits (string length $stop)

    set --local results

    for digit in (seq $start_digits $stop_digits)
        for factor in (factors_for $digit)
            for candidate in (candidates_for $digit $factor)
                if test $candidate -ge $start
                    if test $candidate -le $stop

                        if ! contains $candidate $results
                            set --append results $candidate
                            echo $candidate
                        end
                    end
                end
            end
        end
    end
end

set --local progress 1
for range in $ranges
    set --local ids (string split - "$range")
    set --local start (string trim $ids[1])
    set --local stop (string trim $ids[2])

    for invalid_part_one_id in (invalid_part_one_ids "$start" "$stop")
        set part_one_result (math "$part_one_result + $invalid_part_one_id")
    end

    for invalid_part_two_id in (invalid_part_two_ids "$start" "$stop")
        set part_two_result (math "$part_two_result + $invalid_part_two_id")
    end

    set progress (math "$progress + 1")
end

echo "Part one: $part_one_result"
echo "Part two: $part_two_result"
