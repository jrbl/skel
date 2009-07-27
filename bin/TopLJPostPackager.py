#!/usr/bin/env python
# -*- coding: utf-8 -*-
####################################################################################################

"""Get some user's N most recent public LJ posts; format and dump them."""

import feedparser
import sys
import posix
import getopt
import tempfile


def helpAndExit():
    print sys.argv[0] + """ - Gets some LJ posts and outputs structured permalink list.

Options:
-h        This help.
-d        Debug flag; makes this program chatty.
-n=<N>    Gets <N> most recent public LJ posts.  Defaults to 9.
-u=<USER> Updates from http://<USER>.livejournal.com.  Defaults to jrbl.
-f=<FILE> Outputs to <FILE>.  Defaults to ~jrbl/public_html/lj-shorts.incl.
-c        Copyright information (FIXME)
"""
    sys.exit()


def copyrightAndExit():
    print "ERROR: Not yet implemented."
    sys.exit()


if __name__ == "__main__":

    DEBUG = False
    N     = 9
    user  = 'jrbl'
    ofile = "/home/jrbl/public_html/lj-shorts.incl"

    pairs, remainder = getopt.getopt(sys.argv[1:], 'hdcn:u:f:')
    for pair in pairs:
        if pair[0] == '-h': helpAndExit()
        if pair[0] == '-c': copyrightAndExit()
        if pair[0] == '-d': DEBUG = True
        if pair[0] == '-n': N     = int(pair[1][1:])
        if pair[0] == '-u': user  = pair[1][1:]
        if pair[0] == '-f': ofile = pair[1][1:]

    count = 0
    url   = "http://" + user + ".livejournal.com/data/rss"
    #out   = open(ofile, 'w')
    out   = tempfile.NamedTemporaryFile('w', prefix='ljpost_', dir='.', delete=False)
    oline = "<h2 id=\"blog\">Recent Blog Posts</h2>\n <ul>\n"
    if DEBUG: print oline,
    out.write(oline)
    for post in feedparser.parse(url).entries:
        if count == N: break
        oline  =  "  <li><a href=\"" + post.link + "\">" 
        oline  += post.title + "</a>: "
        oline  += post.updated + "</li>\n"
        if DEBUG: print oline,
        out.write(oline)
        count  += 1

    oline = " </ul>\n"
    if DEBUG: print oline,
    out.write(oline)

    outname = out.name
    out.close()
    posix.chmod(outname, 0644)
    posix.rename(outname, ofile)
