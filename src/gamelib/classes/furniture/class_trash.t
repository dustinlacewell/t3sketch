#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

class Trash: Thing {
    desc = "The trash is a nasty mixture of sheets of paper, food stuffs, various bits of electronic scrap and used tissues."
    aName = 'some <<name>>'


    takeResponder = static new stopChooser(
        {: "Common sense overwhelms and stops you from touching the trash." }, 
        {: "That just isn't in your best interest." }, 
        {: "You just don't see the point." }, 
        {: "You can't convince yourself to go through with it." }, 
        {: "Nope." }
    )

    dobjFor(Take) {
        check() {
            takeResponder.next();
            exit;
        }
    }

}
