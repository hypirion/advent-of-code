# A program to compute Advent Of Code, problem 1-2 2018.
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

elems = STDIN.each_line.map { |x| x.to_i }.to_a

seen = Set{0}
cur = 0

loop do
  elems.each do |x|
    cur += x
    if seen.includes?(cur)
      puts cur
      exit(0)
    end
    seen.add(cur)
  end
end
