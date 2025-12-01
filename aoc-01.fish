set --local rotations (cat $argv[1])
set --local position 50
set --local result 0

for rotation in $rotations
    echo "From $position, rotation $rotation..."

    set --local amount (string match --regex "\d+" "$rotation")
    set amount (math "$amount % 100")
    switch "$rotation"
        case "R*"
            set position (math "$position + $amount")
        case "L*"
            set position (math "$position - $amount")
        case "*"
            echo "WTF $rotation"
            exit 1

    end

    if test "$position" -gt 99
        set position (math "$position - 100")
    else if test "$position" -lt 0
        set position (math "$position + 100")
    end

    echo "...rotated to $position"

    if test "$position" -eq 0
        set result (math "$result + 1")
    end
end

echo "$result"
