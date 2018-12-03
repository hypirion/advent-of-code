#!/usr/bin/env mirah

# A program to compute Advent Of Code, problem 3-1 2018.
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

import java.util.Scanner
import java.util.regex.Pattern
import java.util.regex.Matcher

re = /#\d+ @ (\d+),(\d+): (\d+)x(\d+)/

input = Scanner.new System.in

grid = int[1000*1000]

while input.hasNext do
  m = re.matcher input.nextLine
  if m.matches
    start_x = Integer.parseInt(m.group 1)
    start_y = Integer.parseInt(m.group 2)
    width = Integer.parseInt(m.group 3)
    height = Integer.parseInt(m.group 4)
    start_x.upto(start_x+width-1) do |x|
      start_y.upto(start_y+height-1) do |y|
        grid[y*1000+x] += 1
      end
    end
  end
end

count = 0
grid.each do |val|
  if 1 < val
    count += 1
  end
end
puts count
