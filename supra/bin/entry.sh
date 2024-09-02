#!/bin/bash


# conf
#export SET_X11VNC_SHARED=1
#export SET_IDLETIME=15000
#export SET_IDLE_CONNECTION=30000
#export SUPRA_AUDIO_ON=1
#export SUPRA_APPS_LOOP_ON=1
#export SUPRA_APPS="chrome"


SUPRA_PROJECTOR_BASE_VERSION=1.0.0


launch_setting() {
    export DISPLAY=:11
    echo "projector base verion $SUPRA_PROJECTOR_BASE_VERSION"

    chown -R supra:supra /home/supra  # people may map path in
}


launch_x_and_x11vnc() {
    local shared_opt=-NeverShared
    if [[ -v SET_X11VNC_SHARED ]]; then
        shared_opt=-AlwaysShared
    fi
    mkdir /tmp/.X11-unix
    chmod 1777 /tmp/.X11-unix
    runuser -u supra -- Xvnc $DISPLAY -rfbport 5900 -FrameRate 15 -SendPrimary=0 -SecurityTypes None $shared_opt &> /dev/null &

    local cnt=0
    until xdpyinfo &> /dev/null
    do
        ((cnt=cnt+1))
        if [[ $cnt -gt 1500 ]]; then
            echo "[ERROR] X failed to start in 15s"
            exit 1
        fi
        sleep 0.01
    done
    echo "X is ready"

    cnt=0
    while true
    do
        nc -z 127.0.0.1 5900
        if [[ $? -eq 0 ]];then
            break
        fi
        if [[ $cnt -gt 1500 ]];then
            echo "[ERROR] x11vnc failed to start in 15s"
            exit 1
        fi
        sleep 0.01
        ((cnt=cnt+1))
    done
    echo "x11vnc is ready"

    jobs -l
    echo "X and x11vnc started. shared_opt: $shared_opt"
}


launch_user_conf() {
    echo ''
    echo ''
    printenv | sort -f
    echo 'above are envs app faced'
    echo ''
    echo ''
}


launch_pulseaudio() {
    if ! [[ -v SUPRA_AUDIO_ON ]]; then
        echo "no audio"
        return
    fi
    rm -rf /var/run/pulse /var/lib/pulse /home/supra/.config/pulse

    runuser -u supra -- pulseaudio --exit-idle-time=-1 --high-priority --realtime --no-cpu-limit --disable-shm -vvv &> /dev/null &
    jobs -l
    echo "pulseaudio launched"
}


launch_wm() {
    local openbox_conf=/supra/openbox/rc.xml

    runuser -u supra -- openbox --config-file ${openbox_conf} &> /dev/null &
    runuser -u supra -- picom  &> /dev/null &
    jobs -l
    echo "wm launched. conf_file: ${openbox_conf}"
}


launch_apps() {
    source run-apps.sh
    jobs -l
    echo "apps launched"
}


launch_house_keeping() {
    source house-keeping.sh
    jobs -l
    echo "house-keeping launched"
}


launch_setting

launch_x_and_x11vnc

launch_user_conf

launch_pulseaudio
launch_wm
launch_apps
launch_house_keeping


# Wait for any process to exit
wait -n


# Exit with status of process that exited first
echo 'exiting....'
jobs -l


# if need to keep container for debug, uncomment here
#sleep infinity


exit $?
