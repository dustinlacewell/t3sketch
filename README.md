t3sketch
========

* A system for prototyping and building TADS 3 projects.

t3sketch is a Python module that comes with a handful of scripts for
generating TADS 3 boilerplate that implement Rooms with Doors and Windows. It
also features a handy wrapper around the TADS 3 build system which can
automatically generate reasonable t3m makefiles. Lastly, it features the
ability to generate entire regions of connected floorplans from XML flowcharts
created at http://draw.io/

![living-quarters.png](https://github.com/dustinlacewell/t3sketch/blob/master/t3sketch/example/maps/living-quarters.png?raw=true "example/maps/living-quarters.png")

Installation
------------

If you have pip installed, you can simply:

    $ sudo pip install -e git://github.com/dustinlacewell/t3sketch.git#egg=t3sketch

Otherwise just find a place to clone it and install 'manually':

    $ cd ~/src
    $ git clone git://github.com/dustinlacewell/t3sketch.git
    $ cd t3sketch
    $ sudo python setup.py install

*You're going to need [lxml](http://lxml.de/) installed on your system: 

    $ sudo pip install lxml

    or (on debian/ubuntu)

    $ sudo apt-get install python-lxml

    or visit http://lxml.de/ for help


Demonstration
-------------

Just to showcase what t3sketch can do, let's go ahead and try out the included
example. First, create a new project with `**t3project** <foldername>`:

    $ cd ~/
    $ t3project sketch-test
    $ ls sketch-test
    maps  src  templates

We'll go over these directories in detail later but for now lets just notice
that inside of `maps/` there is an XML file `living-quarters.xml` and
corresponding PNG image shown near the top of this readme:

    $ ls sketch-test/maps
    living-quarters.png  living-quarters.xml

Next, let's just note that in the `src/` directory, we have the following
contents:

    $ ls sketch-test/src
    gamelib  main.t

`src/gamelib is just some miscellaneous Room, Door and utility classes used by
`the demo. src/main.t is the source-file containing the GameID, GameMainDef
`and me objects required to build the TADS story.

Go ahead and use the `**t3map** -l <src dir> <mapxml>` command to turn `maps
/living-quarters.xml` into corresponding TADS 3 source-code with all the Rooms
and Doors implemented just as they are specified in the image above:

***Note:** `t3map` must be run from inside the project directory.*

    $ cd sketch-test
    $ t3map -l src/ maps/living-quarters.xml
    $ ls src/
    gamelib  living-quarters  main.t

Notice how there is a new directory for this map we just built. Inside you
will see a folder for every room:

    $ ls src/living-quarters/
    common-quarters  lq1   lq2  lq6  north-eastern-hall  south-western-hall
    east-hall        lq10  lq3  lq7  north-western-hall  west-hall
    elevator         lq11  lq4  lq8  south-eastern-hall
    elevator-foyer   lq12  lq5  lq9  southern-hall

If we inspect some of the source, we can see all the boilerplate is there:

    $ cat src/living-quarters/common-quarters/common_quarters.t
    #charset "us-ascii"
    #include <adv3.h>
    #include <en_us.h>

    commonQuarters: BaseRoom 'common quarters'
       

        east = commonQuartersEastHallInsideDoor

        west = commonQuartersWestHallInsideDoor

        south = commonQuartersSouthernHallInsideDoor
    ;
    + commonQuartersEastHallInsideDoor: InformativeDoor 'east door' 'east door'
        
    ;
    + commonQuartersWestHallInsideDoor: InformativeDoor 'west door' 'west door'
        
    ;
    + commonQuartersSouthernHallInsideDoor: InformativeDoor 'south door' 'south door'
        
    ;

Finally, to render out the TADS 3 makefile, build it and run the game in a
single step use the `**t3build** [-b] [-r]` command:

    $ t3build -br src/
    IFID = '22f8c17d-8282-4c55-8307-9de13ba33c31'
    name = 'The Example Game'
    byline = 'by Your Name'
    htmlByline = 'by <a href="mailto:youremail@yourdomain.com">Your Name</a>'

    version = '1'
    authorEmail = 'Your Name <youremail@yourdomain.com>'
    desc = 'Test'
    htmlDesc = 'Test'

    Building makefile `the_example_game.t3m`
    Building html makefile `the_example_game_html.t3m`
    Running gamefile `bin/the_example_game.t3`

    Lq1                                      0/0
    Exits: south
    [[Intro text here]]
    Lq1
    The comfortably sized room has a queen sized bed situated against the center
    of the far wall.  A sturdy iron desk juts out from the wall on the right
    facing a bathroom on the opposite side.  A large dresser consume all the space
    of the remaining nearby wall facing the foot of the bed. The south door is
    closed.

    >


Feel free to roam around and verify that the game resembles the floorplan image.