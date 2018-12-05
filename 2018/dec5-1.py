#!/usr/bin/env python3

# A program to compute Advent Of Code, problem 5-1 2018. This is a temporary
# implementation, until I get enough time to implement a Brainfuck version of
# this problem.
# Copyright (C) 2018 Jean Niklas L'orange
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

import sys

line = sys.stdin.read().strip()

out = []

for c in line:
    if not out:
        out.append(c)
    elif c != out[-1] and c.upper() == out[-1].upper():
        out.pop()
    else:
        out.append(c)

print(len(out))
