#!/usr/bin/env io

// A program to compute Advent Of Code, problem 5-2 2018.
// Copyright (C) 2018 Jean Niklas L'orange
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.

// I wanted to use stdin here, but Io said no. :(
// (or did not want to tell me in the documentation)
file := File clone openForReading("input.txt")
line := file readLine
file close

all := "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
best := line size

reacts := method(a, b,
  if (a <= b, (a + 32) == b, reacts(b, a))
)

differentChar := method(a, b,
  (a | 32) != (b | 32)
)

shrunkPolymerSize := method(toRemove,
  s := line asMutable
  i := -1
  for (j, 0, s size - 1,
    if (/* a not here does nothing (?!?) */ differentChar(toRemove, s at (j)),
        if (0 <= i and reacts(s at (i), s at (j))) then (
         i = i - 1
       ) else (
         i = i + 1
         if (i < j, s atPut(i, s at (j)))
       )
    )
  )
  i + 1
)
best := line size
for(i, 0, all size - 1,
  best = best min (shrunkPolymerSize(all at (i)))
)
writeln(best)
