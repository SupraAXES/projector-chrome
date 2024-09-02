reset_x_idle_time() {
    # trick to reset idle time
    echo 'idle xdotool key ctrl'
    xdotool key ctrl
}


check_instance_exit() {
    sleep 30  # wait for bootup
    reset_x_idle_time

    local conn_check=10  # check per 10s
    local cnt=0
    local maxcnt=1  # at least wait 10s
    if [[ -v SET_IDLE_CONNECTION ]];then
        ((maxcnt=maxcnt+SET_IDLE_CONNECTION/(conn_check*1000)))
    fi

    while true
    do
        local count=$(netstat -putan|grep tcp|grep 5900|grep ESTABLISHED|wc -l)
        if [[ $count -eq  0 ]];then
            ((cnt=cnt+1))
            reset_x_idle_time
            if [[ $cnt -gt $maxcnt ]];then
                echo "check connection exit"
                exit 1
            fi
        else
            cnt=0
            local xidletime=$(xprintidle)
            if [[ -v SET_IDLETIME ]] && [[ $xidletime -ge $SET_IDLETIME ]];then
                echo x-idle-time $xidletime
                echo "user idle(no input) exit"
                exit 1
            fi
        fi
        sleep $conn_check
    done
}


check_instance_exit &
