#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

class Breakable: object {
    broken = nil

    breakObj() {
        broken = true;
    }
}