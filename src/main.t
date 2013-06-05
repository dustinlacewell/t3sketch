#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

versionInfo: GameID {
    IFID = '22f8c17d-8282-4c55-8307-9de13ba33c31'
    name = 'The Vault'
    byline = 'by Dustin Lacewell'
    htmlByline = 'by <a href="mailto:dlacewell@gmail.com">Dustin Lacewell</a>'

    version = '1'
    authorEmail = 'Dustin Lacewell <dlacewell@gmail.com>'
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
    location = centerRoom
    posture = sitting
}
