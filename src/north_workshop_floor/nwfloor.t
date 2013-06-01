#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

NorthWorkshopFloor: Room 'North floor of the Workshop'

    desc() {
        choice(
            !self.seen,
            'You see the workshop floor',
            'You see the workshop floor',
        );
    }
;
