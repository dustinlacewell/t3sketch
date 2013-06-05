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

    {% if door_direction %}out = {{ symbol_name }}Door
    {{ door_direction }} asExit(out){% endif %}
;

+ {{ symbol_name }}Door : Door 'door' 'door'
    "Door description"

    masterObject = self
;

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