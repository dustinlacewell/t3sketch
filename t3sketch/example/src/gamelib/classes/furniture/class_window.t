#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

class Window: Occluder, SenseConnector, Fixture

    dobjFor(LookThrough) {
        check() {
            if (nil == connected()) {
                reportFailure('You can\'t seem to actually see through this window.');
                exit;
            }
        }
        action() {
            "You peer into the <<otherLocation.name>>. <<otherLocation.desc>>";
        }
    }   

    connected() {
        return (firstLocation != nil || secondLocation != nil);
    }

    otherLocation() {
        if (connected()) {
            if (gActor.isIn(firstLocation))
                return secondLocation;
            return firstLocation;
        }
    }

    connectedDesc = 'This one provides a view into <<otherLocation.theName>>.'

    disconnectedDesc = 'It seems the active shade on this window has ceased to 
    function causing the entire window to remain permanently opaque.'

    desc = "Standard windowing for the vault. Double paned glass crosshatched 
    with nanocarbon fibre inlay. A slate-colored brushed steel frame seals the 
    edge of the glass. 
    <<if connected>><<connectedDesc>><<else>><<disconnectedDesc>><<end>>"

    inRoomDesc() {
        return ' A <<getState.name>> provides a view into <<otherLocation.theName.toTitleCase>>.';
    }

    connectorMaterial = glass

    firstLocation = nil
    secondLocation = nil

    occludeObj(obj, sense, pov) {
        if (obj.isIn(pov.location)) {
            return nil;
        }
        
        if (obj.isIn(otherLocation)) {
            if (obj.isApparent()) {
                return nil;
            }
        }
        return true;
    }

;

eastWindowState: ThingState
  stateTokens = ['east', 'e']
  name = 'east window'
;

westWindowState: ThingState
   stateTokens = ['west', 'w']
   name = 'west window'
;

northWindowState: ThingState
  stateTokens = ['north', 'n']
  name = 'north window'
;

southWindowState: ThingState
   stateTokens = ['south', 's']
   name = 'south window'
;

southwestWindowState: ThingState
   stateTokens = ['southwest', 's']
   name = 'southwest window'
;

southeastWindowState: ThingState
  stateTokens = ['southeast', 'e']
  name = 'southeast window'
;

northwestWindowState: ThingState
   stateTokens = ['northwest', 'w']
   name = 'northwest window'
;

northeastWindowState: ThingState
  stateTokens = ['northeast', 'n']
  name = 'northeast window'
;
