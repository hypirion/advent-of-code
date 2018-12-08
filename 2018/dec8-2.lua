#!/usr/bin/env lua

-- A program to compute Advent Of Code, problem 8-2 2018.
-- Copyright (C) 2018 Jean Niklas L'orange
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU Affero General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU Affero General Public License for more details.
--
-- You should have received a copy of the GNU Affero General Public License
-- along with this program. If not, see <http://www.gnu.org/licenses/>.

ints = {}
for digit in string.gmatch(io.read(), "%d+") do
  table.insert(ints, tonumber(digit))
end

function makeNode(i, ints)
  local node = {children={}, metadata={}}
  local children = ints[i]
  local metadataEntries = ints[i+1]
  i = i + 2
  for j = 1,children do
    node.children[j], i = makeNode(i, ints)
  end
  for j = 1,metadataEntries do
    node.metadata[j] = ints[i]
    i = i + 1
  end
  return node, i
end

function nodeValue(node)
  local sum = 0
  if node == nil then
    return sum
  elseif #node.children == 0 then
    for i = 1,#node.metadata do
      sum = sum + node.metadata[i]
    end
    return sum
  else
    for i = 1,#node.metadata do
      sum = sum + nodeValue(node.children[node.metadata[i]])
    end
  end
  return sum
end

root = makeNode(1, ints)
print(nodeValue(root))
