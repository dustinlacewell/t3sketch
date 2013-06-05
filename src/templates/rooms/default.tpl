#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

{{ symbol_name }}: Room '{{ room_name }}'

    roomFirstDesc() {
        "The <<name>> room's initial description";
    }

    roomDesc() {
        "The <<name>> room description";
    }
    {% if source_room %}{% if door_direction %}out = {{ symbol_name }}Door
    {{ door_direction }} asExit(out){% endif %}
    {% if exit_direction %}{{ exit_direction}} = {{ source_room }}{% endif %}{% endif %}
;
{% if door_direction %}
+ {{ symbol_name }}Door : Door '{{ door_direction }} door' '{{ door_direction }} door'
    "Door description. "
;{% endif %}
/*

+ {{ symbol_name }}Window : SenseConnector, Fixture 'window' 'window'
    "Window description."

    connectorMaterial = glass

    firstLocation = {{ symbol_name }}
    secondLocation = nil

    locationList = [firstLocation, secondLocation)]

    dobjFor(LookThrough) {
        verify() {}
        check() {}
        action() {
            local otherLocation;
            if(gActor.isIn(firstLocation)) {
                otherLocation = secondLocation;
            } else {
                otherLocation = firstLocation;
            }
            "You peer into the <<otherLocation.name>>";
            gActor.location.listRemoteContents(otherLocation);     
        }
    }   
;

*/