#!/usr/bin/env julia

# A program to compute Advent Of Code, problem 2-1 2018.
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

ids = readlines(stdin)

function frequencies(s)
    d = Dict{Char,Int32}()
    for c ∈ s
        if !haskey(d, c)
            d[c] = 0
        end
        d[c] = d[c] + 1
    end
    return d
end

twos = 0
threes = 0

for id ∈ ids
    freq = frequencies(id)
    if in(2, Set(values(freq)))
        global twos += 1
    end
    if in(3, Set(values(freq)))
        global threes += 1
    end
end

println(twos*threes)
