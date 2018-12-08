#!/usr/bin/env terra

# A program to compute Advent Of Code, problem 8-1 2018.
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

local C = terralib.includecstring [[
  #include <stdio.h>
]]

terra dfs() : int
  var children : int
  var meta_entries : int
  var sum = 0
  C.scanf("%d %d", &children, &meta_entries)
  for i = 0,children do
    sum = sum + dfs()
  end
  for i = 0,meta_entries do
    var tmp : int
    C.scanf("%d", &tmp)
    sum = sum + tmp
  end
  return sum
end

terra main()
  C.printf("%d\n", dfs())
end

main()
