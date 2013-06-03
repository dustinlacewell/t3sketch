#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

choice (cond, first, second) {
    if (cond)
        first();
    else
        second();
}

isSitting (obj) {
    if (obj.posture == sitting)
        return true;
}

isStanding (obj) {
    if (obj.posture == standing)
        return true;
}

isBroken(obj) {
    if (obj.ofKind(Breakable))
        return obj.broken;
}

#ifdef __DEBUG
    #define debugCom(name, code) \
        grammar debugCom : name : BasicProd execute() code
#else
    #define dbgCommand(name, code)
#endif
