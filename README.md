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