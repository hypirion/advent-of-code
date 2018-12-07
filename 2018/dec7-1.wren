#!/usr/bin/env wren

// A program to compute Advent Of Code, problem 7-1 2018.
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

// I couldn't get ./dec7-1.wren < input.txt to work (it sigabrted for some
// reason), even though Stdin worked fine when using the terminal. Ah well.

import "io" for File
import "os" for Process
import "random" for Random

class MinHeap {
  construct new(less) {
    _less = less
    _data = []
    _elts = {}
  }

  min { _data[0] }
  data { _data }
  count { _data.count }

  push(elt) {
    if (_elts.containsKey(elt)) {
      return
    }
    _data.add(elt)
    _elts[elt] = true
    bubbleUp(data.count - 1)
  }

  pop() {
    var last = _data.removeAt(-1)
    if (_data.count == 0) {
      return last
    }
    var ret = _data[0]
    _data[0] = last
    bubbleDown(0)
    _elts.remove(ret)
    return ret
  }

  bubbleUp(idx) {
    // bubble the element upwards until it is smaller, then bubble down to
    // maintain invariant
    var elt = _data[idx]
    while (idx != 0) {
       var parentIdx = (idx - 1) >> 1
       var parent = _data[parentIdx]
       if (_less.call(parent, elt)) {
         break
       }
       _data[idx] = parent
       idx = parentIdx
    }
    _data[idx] = elt
    bubbleDown(idx)
  }

  bubbleDown(idx) {
    // bubble the element down until the heap invariant is satisfied
    var size = _data.count
    var elt = _data[idx]
    var childIdx = (idx << 1) + 1
    while (childIdx < size) {
      // childIdx = left child, but smaller value may also be to the left
      // (if it exists)
      if (childIdx + 1 < size && _less.call(_data[childIdx+1], _data[childIdx])) {
        childIdx = childIdx + 1
      }
      // if we're smaller than the smallest child, invariant is maintained and
      // we can break out
      if (_less.call(elt, _data[childIdx])) {
        break
      }
      _data[idx] = _data[childIdx]
      idx = childIdx
      childIdx = (idx << 1) + 1
    }
    _data[idx] = elt
  }
}

class Solver {
  construct new(depPairs) {
    // initialisation stuff here
    _completed = {}
    _deps = {}
    _rdeps = {}
    _steps = []
    for (depPair in depPairs) {
      for (step in depPair) {
        if (!_deps.containsKey(step)) {
          _steps.add(step)
          _deps[step] = []
          _rdeps[step] = []
        }
      }
      _rdeps[depPair[0]].add(depPair[1])
      _deps[depPair[1]].add(depPair[0])
    }
  }

  canRun(step) {
    for (dep in _deps[step]) {
      if (!_completed[dep]) {
        return false
      }
    }
    return true
  }

  solve() {
    var order = ""
    var runnable = MinHeap.new { |a, b| a.codePoints[0] < b.codePoints[0] }
    for (step in _steps) {
      if (canRun(step)) {
        runnable.push(step)
      }
    }
    while (0 < runnable.count) {
      var cur = runnable.pop()
      order = order + cur
      _completed[cur] = true
      for (rdep in _rdeps[cur]) {
        if (canRun(rdep)) {
          runnable.push(rdep)
        }
      }
    }
    return order
  }
}

var readData = Fn.new {|fname|
  var lines = File.read(fname).split("\n")
  while (lines[-1] == "") {
    lines.removeAt(-1)
  }
  var depPairs = []
  for (line in lines) {
    depPairs.add([line[5], line[36]])
  }
  return depPairs
}

var join = Fn.new {|strings|
  var lst = ""
  var first = true
  for (arg in Process.allArguments) {
    if (!first) {
      lst = lst +  " "
    }
    first = false
    lst = lst + arg
  }
  return lst
}

if (Process.arguments.count != 0) {
  var data = readData.call(Process.arguments[0])
  var solver = Solver.new(data)
  System.print(solver.solve())
} else {
  var progname = join.call(Process.allArguments)
  System.print("usage: %(progname) input-file")
}
