{ pkgs }:

pkgs.writeShellScriptBin "speaker-toggle" ''
        declare -a SINKS_TO_SWITCH=($(wpctl status -n | grep -zoP '(?<=Sinks:)(?s).*?(?=├─)' | grep -a "vol:" | tr -d \* | awk '{print ($3)}'))
        SINK_ELEMENTS=$(echo ${#SINKS_TO_SWITCH[@]})

        ACTIVE_SINK_NAME=$(wpctl status -n | grep -zoP '(?<=Sinks:)(?s).*?(?=├─)' | grep -a '*' | awk '{print ($4)}')
        ACTIVE_ARRAY_INDEX=$(echo ${SINKS_TO_SWITCH[@]/$ACTIVE_SINK_NAME//} | cut -d/ -f1 | wc -w | tr -d ' ')


        if [ $SINK_ELEMENTS -eq 1 ]; then
        exit 0
        fi

        NEXT_ARRAY_INDEX=$((($ACTIVE_ARRAY_INDEX+1)%$SINK_ELEMENTS))
        NEXT_SINK_NAME=${SINKS_TO_SWITCH[$NEXT_ARRAY_INDEX]}

        NEXT_SINK_ID=$(wpctl status -n | grep -zoP '(?<=Sinks:)(?s).*?(?=├─)' | grep -a $NEXT_SINK_NAME | awk '{print ($2+0)}')

        wpctl set-default $NEXT_SINK_ID

        CURRENT_SINK=$(wpctl inspect @DEFAULT_AUDIO_SINK@ | grep 'node\.description' | awk 'BEGIN { FS = "\"" } {print $2}')
        notify-send "Audio Output" "Switched to $CURRENT_SINK"
    ''
