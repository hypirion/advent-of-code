// A program to compute Advent Of Code, problem 3-2 2018.
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

import 'dart:io';
import 'dart:async';

// Not necessary to go this hard to solve the problem, just me trying out the
// class system.
class Fenwick {
  int maxX;
  int maxY;
  List<List<int>> tree;

  Fenwick(x, y) {
    this.maxX = x;
    this.maxY = y;
    tree = new List(x+1);
    for (var i = 0; i <= x; i++) {
      tree[i] = new List<int>.filled(y+1, 0);
    }
  }

  update(x, y, val) {
    var i = 0;
    while (x <= maxX) {
      i = y;
      while (i <= maxY) {
        tree[x][i] += val;
        i += i & -i;
      }
      x += x & -x;
    }
  }

  int get(x, y) {
    var r = 0, i = x;
    while (0 < i) {
      var j = y;
      while (0 < j) {
        r += tree[i][j];
        j -= j & -j;
      }
      i -= i & -i;
    }
    return r;
  }

  int rectSum(x1, y1, width, height) {
    final x2 = x1 + width, y2 = y1 + height;
    return get(x2, y2) - get(x2, y1-1) - get(x1-1, y2) + get(x1-1, y1-1);
  }
}

void main() {
  final re = new RegExp(r'#(\d+) @ (\d+),(\d+): (\d+)x(\d+)');
  var claims = new List();
  while (true) {
    final line = stdin.readLineSync();
    if (line == null) {
      break;
    }
    final data = re.firstMatch(line);
    final claim = data.groups([1,2,3,4,5]).map((x) => int.parse(x)).toList();
    claims.add(claim);
  }
  var grid = new Fenwick(1002, 1002);
  for (var c in claims) {
    final startX = c[1], startY = c[2], width = c[3], height = c[4];
    for (var x = startX; x < startX + width; x++) {
      for (var y = startY; y < startY + height; y++) {
        grid.update(x+1, y+1, 1);
      }
    }
  }
  for (var c in claims) {
    // No destructuring? Madness.
    final id = c[0], startX = c[1], startY = c[2], width = c[3], height = c[4];
    if (grid.rectSum(startX, startY, width, height) == width * height) {
      print('$id');
    }
  }
}
