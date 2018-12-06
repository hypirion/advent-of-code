#!/usr/bin/env elixir

# A program to compute Advent Of Code, problem 6-2 2018.
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

defmodule StringUtil do
  def lines(x) do
    String.split(x, "\n")
  end

  def uncomma(x) do
    String.split(x, ", ")
  end
end

defmodule AOC do
  def solve(pts) do
    start = init_loc(pts)
    region = dfs(pts, start, MapSet.new())
    MapSet.size(region)
  end

  defp manhattan([x0, y0], [x1, y1]) do
    abs(x1 - x0) + abs(y1 - y0)
  end

  defp manhattan_sum(pts, target) do
    Enum.map(pts, &(manhattan(&1, target))) |> Enum.sum
  end

  defp init_loc(pts) do
    num_pts = length pts
    x = Enum.map(pts, &(Enum.at(&1, 0))) |> Enum.sum |> div(num_pts)
    y = Enum.map(pts, &(Enum.at(&1, 1))) |> Enum.sum |> div(num_pts)
    [x, y]
  end

  defp dfs(pts, pt, visited) do
    if MapSet.member?(visited, pt) or 10000 <= manhattan_sum(pts, pt) do
      visited
    else
      v2 = MapSet.put(visited, pt)
      [x, y] = pt
      neighbours = for {dx, dy} <- [{0, 1}, {0, -1}, {1, 0}, {-1, 0}], do: [x+dx, y+dy]
      Enum.reduce(neighbours, v2, fn(pt, v) -> dfs(pts, pt, v) end)
    end
  end

end


data = IO.read(:all) |> String.trim |> StringUtil.lines |> Enum.map(&StringUtil.uncomma/1)
     |> Enum.map(fn nums -> Enum.map(nums, &(elem(Integer.parse(&1), 0))) end)

IO.inspect AOC.solve(data)
