#!/usr/bin/env python2.7
# -*- coding: utf-8 -*-
#
# Use alone or add entropy with noise characters.

import random
import sys

def filter_trash(wordlist):
    return [x for x in 
            [q for q in 
             [W.strip() for W in 
                 [w for w in wordsin if "'" not in w]] 
             if not q[0].isupper()]
            if not x.endswith('ing')]

wordsin = open('/usr/share/dict/american-english', 'rb').readlines()
sys.stdout.write(' '.join(random.sample(filter_trash(wordsin), 4)) + '\n')
