#!/usr/bin/env python

PROJECT = 't3sketch'

# Change docs/sphinx/conf.py too!
VERSION = '0.1'

from setuptools import setup, find_packages

from distutils.util import convert_path
from fnmatch import fnmatchcase
import os
import sys

try:
    long_description = open('README.org', 'rt').read()
except IOError:
    long_description = ''


import fnmatch
import os

def filesfrom(*pathparts):
    files = {}
    path = os.path.join(*pathparts)
    for root, dirnames, filenames in os.walk(path):
        files[root] = []
        for file in filenames:
            files[root].append(os.path.join(root, file))
    return files.items()


setup(
    name='t3sketch',
    version=VERSION,

    description='TADS 3 prototype and build system',
    long_description=long_description,

    author='Dustin Lacewell',
    author_email='dlacewell@gmail.com',

#    url='https://github.com/dustinlacewell/',
#    download_url='https://github.com/dreamhost/cliff/tarball/master',

    classifiers=['Development Status :: 3 - Alpha',
                 'Programming Language :: Python',
                 'Programming Language :: Python :: 2',
                 'Programming Language :: Python :: 2.7',
                 'Programming Language :: Python :: 3',
                 'Programming Language :: Python :: 3.2',
                 'Intended Audience :: Developers',
                 'Environment :: Console',
                 ],

    platforms=['Any'],

    scripts=[
        't3sketch/scripts/t3build',
        't3sketch/scripts/t3door',
        't3sketch/scripts/t3exit',
        't3sketch/scripts/t3map',
        't3sketch/scripts/t3project',
        't3sketch/scripts/t3room',
        't3sketch/scripts/t3window',
    ],

    provides=[],
    install_requires=[
        'jinja2>=dev',
    ],

    dependency_links=[
        'https://github.com/mitsuhiko/jinja2/tarball/master#egg=jinja2-dev',
    ],

    namespace_packages=[],
    packages=find_packages(),
    include_package_data=True,
    zip_safe=False,
    )
