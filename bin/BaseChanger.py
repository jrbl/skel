#!/usr/bin/env python
# -*- coding: utf-8 -*-
#########+#########+#########+#########+#########+#########+#########+#########+#########+#########+#########+#########+
#Copyright (C) 2009  Joe Blaylock <jrbl@jrbl.org>
#
#This program is free software: you can redistribute it and/or modify it under 
#the terms of the GNU General Public License as published by the Free Software 
#Foundation, either version 3 of the License, or (at your option) any later 
#version.
#
#This program is distributed in the hope that it will be useful, but WITHOUT 
#ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or 
#FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more 
#details.
#
#You should have received a copy of the GNU General Public License along with 
#this program.  If not, see <http://www.gnu.org/licenses/>.


"""Converts numbers to and from string representations in arbitrary bases.

For base-8, base-10, base-16, base-24, base-32, base-36, base-62, and base-66,
string->decimal and decimal->string conversions require nothing more than the
number base.  For other bases (or for unexpected use cases) the user must 
supply a character sequence which will be used for the glyphs of the digits.

FIXME: example: b10<->b40
FIXME: example: b10<->b10, letters for #'s
FIXME: example: b10<->b10, #'s jumbled

FIXME: should support math with automatic base conversion.  That'd be rad.
"""

# Imports
from random import randint


# Classes / Data Structures
base_symbols = {8: "01234567",
               10: "0123456789",
               16: "0123456789abcdef",
               24: "0123456789abcdefghijklmn",
               32: "0123456789abcdefghijklmnopqrstuv",
               36: "0123456789abcdefghijklmnopqrstuvwxyz",
               62: "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
               66: "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-_.~",  # RFC 3986 Unreserved Characters
}

class BaseChanger(object):
    def __init__(self, base_value, base_charset = None):
        self.setArbitraryBase(base_value, base_charset)

    def getArbitraryBase(self):
        return self.base

    def setArbitraryBase(self, b, charset=None):
        """Set the encoding base to and from which values will be converted."""
        if (charset == None) and (b not in base_symbols.keys()):
            raise ValueError, "Strange bases require a charset."
        elif (charset != None):
            self.charset = charset
        else:
            self.charset = base_symbols[b]
        self.base = b

    def toArbitraryBase(self, i):
        """Convert i to a base-whatever encoded string."""
        s = ''
        remainder = i
        while remainder > (self.base - 1):
           i = remainder / self.base
           remainder = remainder % self.base
           s += self.charset[i]
           print i, remainder, s
        s += self.charset[remainder]
        return s

    def toDecimal(self, s):
        """Convert a string encoded in base-whatever to a python integer"""
        if (self.base <= 36):
            return int(s, self.base)
        else:
            return self.__decimalHelper(s)

    def __decimalHelper(self, s):
        val = 0
        mult = 1
        for i in range(len(s), 0, -1):
            c = s[i-1]
            num = self.charset.find(c)
            val += num * mult
            mult *= 10 
        return val


# Utility Functions


# Test Harness
if __name__ == "__main__":
    pass

