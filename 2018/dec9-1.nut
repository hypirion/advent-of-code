// It's Squirrel!

/*
 * A program to compute Advent Of Code, problem 9-1 2018.
 * Copyright (C) 2018 Jean Niklas L'orange
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
*/

// More like struct, I guess.
class Marble {
  constructor(v) {
    idx = v;
    val = v;
  }

  idx = 0;
  val = 0;
  prev = 0;
  next = 0;
}

function max(x,y) {
   return x < y ? y : x;
}

function solve(num_players, num_marbles) {
  local player_score = []; player_score.resize(num_players);
  foreach (i, _ in player_score) {
    player_score[i] = 0;
  }
  local marbles = []; marbles.resize(num_marbles);
  foreach (i, _ in marbles) {
    marbles[i] = Marble(i);
  }
  local marble_idx = 0;
  for (local i = 1; i < num_marbles; i++) {
    if (i % 23 == 0) {
      player_score[i % num_players] += i;
      for (local j = 0; j < 6; j += 1) {
        marble_idx = marbles[marble_idx].prev;
      }
      local cur = marbles[marble_idx];
      player_score[i % num_players] += marbles[cur.prev].val;
      local new_prev = marbles[marbles[cur.prev].prev]
      cur.prev = new_prev.idx;
      new_prev.next = cur.idx;
    }
    else {
      local next = marbles[marbles[marble_idx].next];
      local cur = marbles[i];
      local nnext = marbles[next.next];
      next.next = cur.idx;
      cur.prev = next.idx;
      cur.next = nnext.idx;
      nnext.prev = cur.idx;
      marble_idx = i;
    }
  }
  local best = 0;
  foreach (score in player_score) {
    best = max(best, score);
  }
  return best;
}

if (vargv.len() != 2) {
  print("usage: sq dec9-1.nut players last_marble\n");
} else {
  local num_players = vargv[0].tointeger();
  local num_marbles = vargv[1].tointeger() + 1;
  print(solve(num_players, num_marbles) + "\n");
}
