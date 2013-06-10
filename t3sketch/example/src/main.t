#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

versionInfo: GameID {
    IFID = '22f8c17d-8282-4c55-8307-9de13ba33c31'
    name = 'The Example Game'
    byline = 'by Your Name'
    htmlByline = 'by <a href="mailto:youremail@yourdomain.com">Your Name</a>'

    version = '1'
    authorEmail = 'Your Name <youremail@yourdomain.com>'
    desc = 'Test'
    htmlDesc = 'Test'
}

gameMain: GameMainDef {
    initialPlayerChar = me

    showIntro() {
        "[[Intro text here]]";
    }
}

me: Actor {
    location = lq1
    posture = standing
}
