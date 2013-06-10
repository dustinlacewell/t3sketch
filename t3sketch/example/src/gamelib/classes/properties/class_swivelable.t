#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

class Swivelable: object

    swivelEvents: StopEventList {[
        {: mainReport('It swivels.') }
    ]}

    doSwivel() {
        swivelEvents.doScript();
    }
;

SwivelAction: IAction 

    execAction() {
        local loc = gActor.location;
        if (loc.ofKind(Swivelable)) {
            loc.doSwivel();
        } else {
            "You uselessly shake your hips.";
        }
    }
;

VerbRule(Swivel)
    'swivel' | 'spin'
    : SwivelAction
    verbPhrase = 'swivel/swiveling'
;