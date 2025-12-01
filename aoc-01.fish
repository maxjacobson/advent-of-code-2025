set --local rotations (cat $argv[1])
set --local position 50
set --local part_one_result 0
set --local part_two_result 0

for rotation in $rotations
    set --local amount (string match --regex "\d+" "$rotation")
    set --local direction

    switch "$rotation"
        case "R*"
            set direction 1
        case "L*"
            set direction -1
        case "*"
            echo "WTF $rotation"
            exit 1

    end

    for n in (seq 1 "$amount")
        set position (math "$position + $direction")

        if test "$position" -gt 99
            set position (math "$position - 100")
        else if test "$position" -lt 0
            set position (math "$position + 100")
        end

        if test "$position" -eq 0
            set part_two_result (math "$part_two_result + 1")
        end
    end

    if test "$position" -eq 0
        set part_one_result (math "$part_one_result + 1")
    end
end

echo "Part one: $part_one_result"
echo "Part two: $part_two_result"
