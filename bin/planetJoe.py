#!/usr/bin/env python
# -*- coding: utf-8 -*-
####################################################################################################

"""Get some user's N most recent public LJ posts; format and dump them."""

import feedparser
import sys
import codecs
import optparse
from datetime import datetime


FEEDS = [
         #    URL                                    Label            Link it?
         ("http://USER.livejournal.com/data/atom", "Blogging",        True), 
         ("http://github.com/USER.atom",           "Developing",      True), 
         ("https://identi.ca/api/statuses/user_timeline/USER.atom", 
                                                   "Tweeting",        False),
         ("http://api.flickr.com/services/feeds/photos_public.gne?id=17873302@N00&lang=en-us&format=atom",
                                                   "Photography",     True),
        ]

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

def postGenerator(url, max, filter = lambda x: x): 
    count = 0 
    date = ''
    for post in feedparser.parse(url).entries:
        if count == max: break
        if filter(post.title):
            count += 1
            try:
                date = post.published[:19]
            except AttributeError:
                date = "%d-%02d-%02d %02d:%02d" % post.updated_parsed[0:5]
            try:
                title = post.title.decode('utf-8')
            except UnicodeEncodeError:
                title = post.title
            yield date, title, post.link

def outputGenerator(header, input, linkit=True):
    yield "<h3 class=\"blog\">%s</h3>\n <ul class=\"activity\">\n" % header
    for date, title, link in input:
        if linkit:
            yield "<li><a href=\"%s\">%s</a>: <span style=\"font-size:x-small;\">%s</span></li>\n" % (link, title, unicode(date))
        else:
            yield "<li>%s: <span style=\"font-size:x-small;\">%s</span></li>\n" % (heat_links(title), unicode(date))
    yield " </ul>\n"

def heat_links(title):
    toks = title.split()
    ret_toks = []
    for tok in toks:
        if tok.startswith("http://") or tok.startswith("https://"):
            ret_toks.append('<a href="'+tok+'">'+tok+'</a>')
        else:
            ret_toks.append(tok)
    return ' '.join(ret_toks)

def filterIdenticaTargetted(msg):
    return (msg.find('@') == -1)

def filterGitHubGHPages(msg):
    return (msg.find('pushed to gh-pages at') == -1)

def filters(msg):
    return filterIdenticaTargetted(msg) and filterGitHubGHPages(msg)


if __name__ == "__main__":

    parser, options, args = configOptParse()

    if (len(sys.argv) == 0) or (not options.outfile):
        parser.print_help()
        sys.exit()
    debug = getDebugFunc(options.debug_flag)
    if options.outfile == "-":
        out = sys.stdout
    else:
        out = codecs.open(options.outfile, 'w', 'utf-8')

    out.write("<h2 class=\"blog\">Recent Activity</h2>\n")
    for feed in FEEDS:
        url = feed[0]
        title = feed[1]
        linkit = feed[2]
        for line in outputGenerator(title, 
                                    sorted(postGenerator(url.replace('USER', options.user), 
                                                         options.number, 
                                                         filter=filters), 
                                           reverse=True),
                                    linkit):
            debug(line, True)
            out.write(line)

    outname = out.name
    if outname != '<stdout>':
        out.close()
