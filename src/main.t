#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

versionInfo: GameID {
    IFID = '22f8c17d-8282-4c55-8307-9de13ba33c31'
    name = 'The Space'
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
        "<p>You take a long drag from your ciggarette. Hold it in to feel its effects course through your veins before letting it out in a long sigh. You don't even enjoy it anymore. It's certainly not allowed in the building. Not that anyone is going to raise any alarms. You're alone.</p>";

        "<p>You swivel slightly in your chair to get a better look through the dusty office window. Your face curves slightly upwards on one side of your mouth. You smile. You can't help to think that just four months ago this place was unfit for rats. Your eyes look down the row of sturdy unfinshed tables lining the floor. Now, every two weeks, this place is a nexus for the inspired. And it's really starting to pay off too. Even you find yourself anticipating the completion of some of the projects out there. It took a lot of elbow greese and more face-time with city officials than you imagined you could withstand but hey - the city's first hacker space.</p>";
    }
}

me: Actor {
    location = officeChair
    posture = 'sitting'
}

office: Room 'Office' {
    desc = "<p><<one of>>You swivel away from the window and your mind returns to the office.<<or>>You survey the office.<<stopping>> Its a small unfurnished room.";
}

+ officeChair: BasicChair {
    vocabWords = 'chair'
    weakTokens = 'office'
    name = 'office chair'
    desc = "Its a small office chair with four wheels and seat the swivels.";
}
