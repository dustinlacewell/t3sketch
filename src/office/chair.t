#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

officeChair: Breakable, BasicChair {
    location = office

    name = 'office chair'
    vocabWords = 'chair'
    weakTokens = 'office'
    broken = nil

    desc() {
        choice(
            isSitting(gActor),
            'It\'s a bit hard to examine while sitting on it.',
            'It\'s a small office chair with four wheels and a seat <<if broken>>that used to swivel.<<else>>the swivels.<<end>>'
        );
    }

    initSpecialDesc = "";
}

SwivelAction: IAction {

    events: StopEventList {[
        {: mainReport('The chair squeeks. Whee!') },
        {: mainReport('The chair squeeks. Whee!') },
        {: mainReport('The chair squeeks. Whee!') },
        {: mainReport('Whee!') },
        {: mainReport('The chair emits a dry groan. It turns with difficulty.') },
        {: mainReport('The chair refuses to swivel. Too much of a good thing you suppose.') },
        {: mainReport('The chair refuses to swivel.') }
    ]}

    execAction() { 
        if (isSitting(gActor)) {
            events.doScript(); 
            if (gActor.location.broken == nil) {
                if (events.curScriptState == events.eventListLen)
                    gActor.location.broken = true;
            }
        } else {
            "You uselessly shake your hips.";
        }
    }
}

VerbRule(Swivel)
    'swivel'
    : SwivelAction
    verbPhrase = 'swivel/swiveling'
;