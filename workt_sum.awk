#!/usr/bin/awk -f

{
    split($3, s, ":")

    if(/START#/) 
        minin=s[1]*60+s[2]

    if(/END#/) {
        minut=s[1]*60+s[2]
        days[$2]+=minut-minin
        minin=minut=0
    }
}

END {
    for(d in days)
        printf "%s: %.2f\n", d, days[d]/60

}

