#####################
# General functions
#####################

function contains() {
    local n=$#
    local value=${!n}
    for ((i=1;i < $#;i++)) {
        if [ "${!i}" == "${value}" ]; then
            echo "yes"
            return 0
        fi
    }
    echo "no"
    return 1
}

in_array () {
    # Test if array contains the specified element
    # :param: element to search
    # :param: array to search in
    local e match="$1"
    shift
    for e; do [[ "$e" == "$match" ]] && return 0; done
    return 1
}


log () {
    # Display log messages
    # :param: Log level : error, info or debug
    # :param: Message

    local now delta
    if [ "$1" != "debug" ] || { [ "$1" = "debug" ] && [ "$DC_DEBUG" = 1 ];}; then
        case "$1" in
            error)
                prefix="$RED Error : "
            ;;
            info)
                prefix=" Info : "
            ;;
            debug)
                prefix="$CYAN Debug : "
            ;;
            *)
                prefix=""
            ;;
        esac

        if [ "$DC_PERFTRACE" = 1 ]; then
            now=$(date "+%s%N" |cut -b1-13)
            delta=$((now-LAST_LOG_TIME))
            LAST_LOG_TIME="$now"
            printf "%-10s$SHLVL$prefix$EOC%s\n" "$delta" "$2" 1>&2
        else
            printf "%s$SHLVL$prefix%s$EOC%s\n" "$(date +'%Y/%m/%d %H:%M:%S')" "$2" 1>&2
        fi
    fi
}

get_current_dir () {
    # Determine directory for current script
    HERE="$( cd "$( dirname "$0" )" >/dev/null && pwd )"
    echo $HERE
}
