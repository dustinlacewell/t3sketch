#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

class Chooser: OneOfIndexGen
    construct(type, [elements]) {
        listAttrs = type;
        numItems = elements.length();
        items = elements;
    }

    next() {
        local f = items[self.getNextIndex()];
        return f();
    }
;

class randChooser: Chooser 
    construct([elements]) {
        inherited('rand', elements...);
    }
;    

class shufChooser: Chooser 
    construct([elements]) {
        inherited('shuffle2', elements...);
    }
;    

class stopChooser: Chooser 
    construct([elements]) {
        inherited('seq,stop', elements...);
    }
;    

class cycleChooser: Chooser 
    construct([elements]) {
        inherited('seq', elements...);
    }
;


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
