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

    set --local remaining_digits $argv[2]
    set --local untouchable_amount (math "$remaining_digits - 1")
    set --local candidates

    if test $remaining_digits -eq 1
        set candidates "$bank"
    else
        set candidates (string sub --end "-$untouchable_amount" "$bank")
    end

    set --local highest_digit_among_candidates_info (highest_digit "$candidates")

    set --local remaining_bank_starting_point (math "$highest_digit_among_candidates_info[2] + 1")
    set --local remaining_bank (string sub "$bank" --start "$remaining_bank_starting_point")

    if test $remaining_digits -eq 1
        echo $highest_digit_among_candidates_info[1]
    else
        set --local digits_to_follow (maximum_joltage_for "$remaining_bank" (math "$remaining_digits - 1"))

        echo "$highest_digit_among_candidates_info[1]$digits_to_follow"
    end
end

function main
    set --local input (cat $argv[1])
    set --local part_one_result 0
    set --local part_two_result 0

    for bank in $input
        set --local part_one_maximum_joltage (maximum_joltage_for $bank 2)
        set --local part_two_maximum_joltage (maximum_joltage_for $bank 12)

        set part_one_result (math "$part_one_result + $part_one_maximum_joltage")
        set part_two_result (math --scale=0 "$part_two_result + $part_two_maximum_joltage")
    end

    echo "Part one: $part_one_result" # 17376
    echo "Part two: $part_two_result" # 172119830406258
end

main $argv[1]
