#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

class SwivelChair: Swivelable, Chair
    desc() {
        choice(
            isSitting(gActor),
            {: "It's a bit hard to examine while sitting on it." },
            {: "It's a small chair with four wheels and a seat that swivels." }
        );
    }

    swivelEvents: StopEventList {[
        {: mainReport('The chair sqeeks. Whee!') }
    ]}
;

class BreakableSwivelChair: Breakable, SwivelChair
    desc() {
        choice(
            isSitting(gActor),
            {: "It's a bit hard to examine while sitting on it." },
            {: "It's a small office chair with four wheels and a seat <<if isBroken(self)>>that used to swivel.<<else>>that swivels.<<end>>" }
        );
    }

    swivelEvents: StopEventList {[
        {: mainReport('The chair squeeks. Whee!') },
        {: mainReport('The chair squeeks. Whee!') },
        {: mainReport('Whee!') },
        function() {
            officeChair.breakObj();
            mainReport('The chair emits a dry groan. It turns with difficulty.');
        },
        {: mainReport('The chair refuses to swivel. Too much of a good thing you suppose.') },
        {: mainReport('The chair refuses to swivel.') }
    ]}
;

#ifdef __DEBUG

Test 
    testName = 'swivel' 
    testList = [
        'stand',
        'x chair',
        'sit',
        'swivel',
        'swivel',
        'swivel',
        'swivel',
        'stand',
        'x chair'
    ]
;

#endif