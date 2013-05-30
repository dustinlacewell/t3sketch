#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

officeChair: BasicChair {
    location = office

    name = 'office chair'
    vocabWords = 'chair'
    weakTokens = 'office'

    desc = "<<if isSitting(me)>>It's a bit hard to examine while sitting on it.<<else>>Its a small office chair with four wheels and seat the swivels.<<end>>";
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

    execAction() { events.doScript(); }
}

VerbRule(Swivel)
    'swivel'
    : SwivelAction
    verbPhrase = 'swivel/swiveling'
;
