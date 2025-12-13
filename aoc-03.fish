set --local input (cat $argv[1])
set --local part_one_result 0

function highest_digit
    set --local digits (string split "" $argv[1])

    set --local index 1
    set --local highest -1
    set --local highest_index -1

    while test $index -le (count $digits)
        set --local digit $digits[$index]

        if test $digit -gt $highest
            set highest $digit
            set highest_index $index
        end

        set index (math "$index + 1")
    end

    string split "," "$highest,$highest_index"
end

function maximum_joltage_for
    set --local bank $argv[1]
    set --local bank_without_last_digit (string sub --end -1 $bank)
    set --local highest_first_digit_info (highest_digit $bank_without_last_digit)
    set --local highest_second_digit_info (highest_digit (string sub --start (math "$highest_first_digit_info[2] + 1") $bank))

    echo "$highest_first_digit_info[1]$highest_second_digit_info[1]"
end

for bank in $input
    set --local maximum_joltage (maximum_joltage_for $bank)

    set part_one_result (math "$part_one_result + $maximum_joltage")
end

echo "Part one: $part_one_result"
