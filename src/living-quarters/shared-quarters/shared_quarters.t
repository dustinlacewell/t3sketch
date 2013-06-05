#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

sharedQuarters: Room 'shared quarters'

    roomFirstDesc() {
        "The <<name>> room's initial description";
    }

    roomDesc() {
        "The <<name>> room description";
    }

;

/*

+ sharedQuartersWindow : SenseConnector, Fixture 'window' 'window'
    "Window description."

    connectorMaterial = glass

    firstLocation = sharedQuarters
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