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

function id_invalid_part_two
    set --local id $argv[1]
    set --local length (string length $id)

    for sub_string_length in (seq 1 (math "$length - 1"))
        if test (math "$length % $sub_string_length") -ne 0
            continue
        end

        set --local sub_string (string sub --length $sub_string_length $id)

        set --local repetitions (math "$length / $sub_string_length")

        if test (string repeat --count "$repetitions" "$sub_string") -eq "$id"
            return 0
        end
    end

    false
end

string join '' -- "There are " (count $ranges) " ranges"

set --local progress 1
for range in $ranges
    string join '' -- "[" (date) "]" " checking range $progress"
    set --local ids (string split - "$range")
    set --local stop (string trim $ids[2])

    set --local id (string trim $ids[1])

    while test $id -le $stop
        # if id_invalid_part_one "$id"
        #     set part_one_result (math "$part_one_result + $id")
        # end

        if id_invalid_part_two "$id"
            set part_two_result (math "$part_two_result + $id")
        end

        set id (math "$id + 1")
    end

    set progress (math "$progress + 1")
end

echo "Part one: $part_one_result"
echo "Part two: $part_two_result"
