#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

office: Room 'Office'

    desc() {
        choice(
            !self.seen,
            '<p>You swivel away from the window and the single naked bulb
            hanging overhead flickers as your mind returns to the office.
            Its a small unfurnished room where you store paperwork and
            organize promotions. Mostly this is where you come when you
            just need a break from the social exposure. A paper mountain
            precariously straddles the surface area of a massive olive desk
            that takes up half the room with its steely girth. You ash the
            burning ciggarette in your hand into a tray resting there. A
            large calendar takes up most of the north wall save for a filing
            cabinet in the corner. You notice the wastebin at your feet needs
            changing.</p>'

            '<p>You survey the office. 
            <<if isSitting(gActor)>>You sit <<else>>You stand<<end>>
            before a desk as wide as the room snugged against the back wall.
            A calendar and filing-cabinet occupy the north wall while a large
            window provides a view onto the workshop floor.</p>',
        );
    }
;

+ officeWindow : SenseConnector, Fixture 'window' 'dusty window'
    "The dusty window takes the majority of the south wall next
    to the door allowing you a good view of the workshop floor"

    connectorMaterial = glass
    locationList = [northFloor, office]

    dobjFor(LookThrough) {
        verify() {}
        check() {}
        action() {
            local otherLocation;
            if(gActor.isIn(office)) {
                otherLocation = northFloor;
                "You squint past the dust and into the large workshop.";
            } else {
                otherLocation = office;
                "You squint pas the dust and into the tiny office.";
            }

            gActor.location.listRemoteContents(otherLocation);     
        }
    }   
;