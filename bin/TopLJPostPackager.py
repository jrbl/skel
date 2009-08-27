#!/usr/bin/env python
# -*- coding: utf-8 -*-
####################################################################################################

"""Get some user's N most recent public LJ posts; format and dump them."""

import feedparser
import sys
import posix
import optparse
import tempfile
from datetime import datetime


def getDebugFunc(flag):
    def _true(message, terminated):
        sys.stderr.write(unicode(datetime.now()) + ' ' + message )
        if not terminated: sys.stderr.write('\n')
        sys.stderr.flush()
    def _false(ignored, alsoignored):
        pass
    if flag: return _true
    else: return _false

def postGenerator(url, max, strp_string):
    count = 0
    for post in feedparser.parse(url).entries:
        if count == max: break
        yield datetime.strptime(post.updated), post.title, post.link
        count += 1

if __name__ == "__main__":

    parser = optparse.OptionParser(usage = "%prog [options] [-o outfile]")
    parser.add_option('-d', '--debug', dest="debug_flag", action="store_true", default=False,
                      help="Enable debug output.  Defaults to off")
    parser.add_option('-n', '--number', dest="number", action="store", metavar="N", default=9,
                      help="Get N most recent public LJ posts.  Defaults to 9")
    parser.add_option('-u', '--user', dest="user", action="store", metavar="USER", default='jrbl',
                      help="Updates from http://USER.livejournal.com.  Defaults to jrbl")
    parser.add_option('-o', '--outfile', dest="outfile", action="store", metavar="FILE",
                      help="Output to FILE.  No default value")
    options, args = parser.parse_args()

    if (len(sys.argv) == 0) or (not options.outfile):
        parser.print_help()
        sys.exit()
    debug = getDebugFunc(options.debug_flag)

    count = 0
    url   = "http://" + options.user + ".livejournal.com/data/atom"
    out   = tempfile.NamedTemporaryFile('w', prefix='ljpost_', dir='.', delete=False)
    oline = "<h2 id=\"blog\">Recent Blog Posts</h2>\n <ul>\n"
    debug(oline, True)
    out.write(oline)

    for post in feedparser.parse(url).entries:
        if count == options.number: break
        oline  =  "  <li><a href=\"" + post.link + "\">" 
        oline  += post.title + "</a>: "
        oline  += post.updated + "</li>\n"
        debug(oline, True)
        out.write(oline)
        count  += 1

    oline = " </ul>\n"
    debug(oline, True)
    out.write(oline)

    outname = out.name
    out.close()
    posix.chmod(outname, 0644)
    posix.rename(outname, options.outfile)
