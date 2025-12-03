set --local input (cat $argv[1])
set --local ranges (string split , "$input")
set --local result 0

function idInvalid
    set --local id $argv[1]
    set --local length (string length $id)

    if test (math "$length % 2") -eq 0
        set --local length (string length $id)
        set --local halfWayPoint (math "$length / 2")
        set --local firstHalf (string sub --length "$halfWayPoint" $id)
        set --local secondHalf (string sub --start "-$halfWayPoint" $id)

        test "$firstHalf" -eq "$secondHalf"
    else
        false
    end
end

string join '' -- "There are " (count $ranges) " ranges"

set --local progress 1
for range in $ranges
    string join '' -- "[" (date) "]" " checking range $progress"
    set --local ids (string split - "$range")
    set --local stop (string trim $ids[2])

    set --local id (string trim $ids[1])

    while test $id -le $stop
        if idInvalid "$id"
            set result (math "$result + $id")
        end

        set id (math "$id + 1")
    end

    set progress (math "$progress + 1")
end

echo "Result: $result"
