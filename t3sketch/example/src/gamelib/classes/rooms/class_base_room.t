#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

class BaseRoom: Room
    roomDesc() { inherited; extras; lookAroundWithinShowExits(gActor, brightness); } 

    extras() { 
        foreach(local cur in contents) 
            "<<cur.inRoomDesc>>"; 
    } 
;
