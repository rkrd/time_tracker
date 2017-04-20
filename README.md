# time_tracker
Used to track working time.

time.sh - I think it is pretty pure sh. And thats not nice. Which shows in workt_sum.awk, much nicer and cleaner. The summing in time.sh though is not affected by date changes during START/END.

time.sh - with no arguments shows time since last timestamp in .worktime
time.sh sum - sums all start/end timestamps in .worktime and if last timestamp is a start time from that time to now is also inluded
time.sh start - add a start timestamp right now
time.sh end - add a end timestamp right now
