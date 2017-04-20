#!/bin/bash
TIMEFILE=~/.worktime
DATEFMT="%Y-%m-%d %H:%M"
BREAK=0

append_start() {
    timenow=$(date +"$DATEFMT")
    echo Append start time $timenow
    echo "START# $timenow" >> $TIMEFILE
}

append_end() {
    timenow=$(date +"$DATEFMT")
    echo Append end time $timenow
    echo "END# $timenow" >> $TIMEFILE
}

worked_time() {
    start_time=$(grep START $TIMEFILE | tail -1 | cut -d'#' -f2)
    epoc_start=$(date --date="$start_time" +%s)
    epoc_in=$(date +%s)
    time_diff=$(($epoc_in-$epoc_start))

    minutes=$(($time_diff/60))
    hours=$(($minutes/60))
    echo $hours $(($minutes - ($hours*60)))
}

# If no argument is given sums all dates in $TIMEFILE
# If argument given it is expected to be a filter string, eg 2016-06
# for all dates in june 2016
sum_all() {
    if [ ! "$BREAK" ]
    then
        echo "BREAK not set, set in seconds"
        exit 1
    fi

    i=0
    while IFS=$'\n' read -r line_data
    do
        time=$(echo $line_data | cut -d'#' -f2)
        times[i]=$(date --date="$time" +%s)
        #echo ${times[i]}
        true $((i++))
    done < <(cat $TIMEFILE | grep "$1")

    # If last line is not an end time append current time.
    if tail -n1 $TIMEFILE | grep -q START; then
        times[i]=$(date +%s)
    fi

    #echo ${#times[@]}
    i=0
    while [ $i -lt ${#times[@]} ]
    do
        next=$((i+1))
        time_diff=$((${times[$next]}-${times[i]}-$BREAK))

        minutes=$(($time_diff/60))
        hours=$(($minutes/60))
        day=$(date --date=@"${times[$i]}" +"w%U %b %d")
        #echo $day: $hours:$(($minutes - ($hours*60)))
	printf '%s: %d,%02d\n' "$day" $hours $((($minutes - ($hours*60))*100/60))
        i=$((next+1))
    done
}

case $1 in
    start)
        append_start
        ;;
    end)
        append_end
        ;;
    sum)
        if [ "$2" ]
        then
            sum_all $2
        else
            sum_all .
        fi
        ;;
    *)
        worked_time 
        ;;
esac

