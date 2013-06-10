#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

class LivingQuarters: Room

    owner = nil

    possesion_desc() {
        if (self.owner)
            return 'personal quarters of <<owner>>';
        return 'room';
    }

    roomDesc() {
        "The comfortably sized <<possesion_desc>> has a queen sized bed situated against the center of the far wall.
        A sturdy iron desk juts out from the wall on the right facing a bathroom on the opposite side. A large dresser
        consume all the space of the remaining nearby wall facing the foot of the bed.";
    }
;