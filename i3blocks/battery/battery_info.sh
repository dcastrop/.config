#!/bin/sh

# If ACPI was not installed, this probably is a battery-less computer.
ACPI_RES=$(acpi -b)
ACPI_CODE=$?
if [ $ACPI_CODE -eq 0 ]
then
    # Get essential information. Due to som bug with some versions of acpi it is
    # worth filtering the ACPI result from all lines containing "unavailable".
    BAT_LEVEL_ALL=$(echo "$ACPI_RES" | grep -v "unavailable" | grep -E -o "[0-9][0-9]?[0-9]?%")
    BAT_LEVEL=$(echo "$BAT_LEVEL_ALL" | awk -F"%" 'BEGIN{tot=0;i=0} {i++; tot+=$1} END{printf("%d%%\n", tot/i)}')
    TIME_LEFT=$(echo "$ACPI_RES" | grep -v "unavailable" | grep -E -o "[0-9]{2}:[0-9]{2}:[0-9]{2}")
    IS_CHARGING=$(echo "$ACPI_RES" | grep -v "unavailable" | awk '{ printf("%s\n", substr($3, 0, length($3)-1) ) }')

    # If there is no 'time left' information (when almost fully charged) we 
    # provide information ourselvs.

    # Print full text. The charging data.
    TIME_LEFT=$(echo $TIME_LEFT | awk '{ printf("%s", substr($1, 0, 5)) }')
    TIME_INFO="⏳$TIME_LEFT"
    if [ -z "$TIME_LEFT" ]
    then
        TIME_INFO="" 
    fi

    BAT_ICON="🔋"
    BAT_COLOR="#007872"
    if [ "$IS_CHARGING" = "Charging" ]
    then 
        BAT_ICON="⚡"
        BAT_COLOR="#D0D000"
    elif [ "$IS_CHARGING" = "Full" ]
    then
        BAT_ICON="⚡"
    else
        if [ "${BAT_LEVEL%?}" -le 15 ]
        then
            # Battery very low. Red color.
            BAT_COLOR="#FA1E44"
        fi
        if [ "${BAT_LEVEL%?}" -le 6 ]
        then
            zenity  --notification --title "alert" --text "NENO ENCHUFA LA CHISMA ESTA: ${BATTERY_ALERT}\!\!\!\!\!"
        fi
    fi 
    echo "${BAT_ICON}${BAT_LEVEL} ${TIME_INFO}"
    # Print the short text.
    echo "BAT: $BAT_LEVEL"
    echo "${BAT_COLOR}"
fi
