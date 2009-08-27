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


def configOptParse():
    parser = optparse.OptionParser(usage = "%prog [options] [-o outfile]")
    parser.add_option('-d', '--debug', dest="debug_flag", action="store_true", default=False,
                      help="Enable debug output.  Defaults to off")
    parser.add_option('-n', '--number', dest="number", action="store", type="int", metavar="N", 
                      default=9, help="Get N most recent public LJ posts.  Defaults to 9")
    parser.add_option('-u', '--user', dest="user", action="store", metavar="USER", default='jrbl',
                      help="Substituted for USER into the resource URL.  Defaults to jrbl")
    parser.add_option('-r', '--resource', dest="url", action="store", metavar="URL", 
                      default='http://USER.livejournal.com/data/atom',
                      help="Updates from URL (Token USER substituted for value of -u). Defaults to http://USER.livejournal.com/data/atom/")
    parser.add_option('-o', '--outfile', dest="outfile", action="store", metavar="FILE",
                      help="Output to FILE.  - writes to stdout.  No default value")
    options, args = parser.parse_args()
    return parser, options, args

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
        count += 1
        dt = datetime.strptime(post.updated[0:19], strp_string)
        yield dt, post.title, post.link

def lotsaParsers(options):
    feeds = [
             "http://USER.livejournal.com/data/atom", 
             "http://github.com/USER.atom",
             "https://identi.ca/api/statuses/user_timeline/USER.atom",
            ]
    posts = []
    for feed in feeds:
        gen = postGenerator(feed.replace('USER', options.user), 
                            options.number, "%Y-%m-%dT%H:%M:%S")
        posts.extend([x for x in gen])
    posts.sort(reverse=True)
    return posts[:options.number]

def outputGenerator(header, input):
    yield "<h2 id=\"blog\">%s</h2>\n <ul>\n" % header
    for date, title, link in input:
        yield "<li><a href=\"%s\">%s</a>: %s\n" % (link, title, unicode(date))
    yield " </ul>\n"

if __name__ == "__main__":

    parser, options, args = configOptParse()

    if (len(sys.argv) == 0) or (not options.outfile):
        parser.print_help()
        sys.exit()
    debug = getDebugFunc(options.debug_flag)
    if options.outfile == "-":
        out = sys.stdout
    else:
        out   = tempfile.NamedTemporaryFile('w', prefix='ljpost_', dir='.', delete=False)

    for line in outputGenerator("Recent Internet Activity", lotsaParsers(options)):
        debug(line, True)
        out.write(line)

    outname = out.name
    if outname != '<stdout>':
        out.close()
        posix.chmod(outname, 0644)
        posix.rename(outname, options.outfile)
