#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

doors: ListGroupSorted    
;

class InformativeDoor: Apparent, Door {
    inRoomDesc() {
        local dest = getApparentDestination(gActor.location, gActor);
        if (dest || isOpen()) {
            return ' \^<<theName>> <<if isOpen>>is open<<else>>is closed<<end>> and leads to <<destination.theName.toTitleCase>>. ';
        } else {
            return ' \^<<theName>> is closed.';
        }
    }
}
