function analyze_paper_rolls
    set --local map $argv[1]

    set --local y 1

    for line in (string split " " "$map")
        set --local x 1
        for char in (string split "" "$line")
            if test $char = "@"
                echo "$x,$y"
            end
            set x (math "$x + 1")
        end

        set y (math "$y + 1")
    end
end

function lookup
    set --local x $argv[1]
    set --local y $argv[2]
    set --local map $argv[3]

    if test "$x" -lt 1
        or test "$y" -lt 1
        return 0
    end

    set --local lines (string split " " "$map")
    set --local line $lines[$y]
    set --local chars (string split "" "$line")
    echo $chars[$x]
end

function neighboring_paper_rolls
    set --local result 0

    set --local x $argv[1]
    set --local y $argv[2]
    set --local map $argv[3]
    set --local neighbor_coordinates

    for xdelta in (seq -1 1)
        for ydelta in (seq -1 1)
            if test "$ydelta" -eq 0
                and test "$xdelta" -eq 0

                continue
            end

            set --local neighborX (math "$x + $xdelta")
            set --local neighborY (math "$y + $ydelta")

            set --local neighbor (lookup "$neighborX" "$neighborY" "$map")

            if test "$neighbor" = "@"
                set result (math "$result + 1")
            end
        end
    end

    echo $result
end

function remove_paper_roll
    set --local x $argv[1]
    set --local y $argv[2]
    set --local map $argv[3]

    set --local lines (string split " " "$map")
    set --local line $lines[$y]
    set --local chars (string split "" "$line")
    set chars[$x] "."
    set lines[$y] (string join "" $chars)
    string join " " $lines
end

function main
    set --local map (cat $argv[1])

    set --local part_one_result 0
    set --local part_two_result 0

    set --local map (cat $argv[1])

    for paper_roll in (analyze_paper_rolls "$map")
        set --local coordinates (string split "," "$paper_roll")
        set --local count (neighboring_paper_rolls "$coordinates[1]" "$coordinates[2]" "$map")

        if test "$count" -lt 4
            set part_one_result (math "$part_one_result + 1")
        end
    end

    echo "Part one: $part_one_result"

    while true
        set --local did_remove_any nope

        for paper_roll in (analyze_paper_rolls "$map")
            set --local coordinates (string split "," "$paper_roll")
            set --local count (neighboring_paper_rolls "$coordinates[1]" "$coordinates[2]" "$map")

            if test "$count" -lt 4
                set map (remove_paper_roll "$coordinates[1]" "$coordinates[2]" "$map")
                set did_remove_any yep
                set part_two_result (math "$part_two_result + 1")
            end
        end

        if test "$did_remove_any" = nope
            break
        end
    end

    echo "Part two: $part_two_result"
end

main "$argv[1]"
