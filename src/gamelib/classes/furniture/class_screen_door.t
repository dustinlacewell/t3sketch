#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

class ScreenDoor: AutoClosingDoor {
    desc = "A wooden-framed screen door on a spring-loaded hinge."
    reportAutoClose() { 
        mainReport('The door swings shut behind you.'); 
    }
}

