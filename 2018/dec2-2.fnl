;; Fennel: https://fennel-lang.org

;; A program to compute Advent Of Code, problem 2-2 2018.
;; Copyright (C) 2018 Jean Niklas L'orange
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU Affero General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU Affero General Public License for more details.
;;
;; You should have received a copy of the GNU Affero General Public License
;; along with this program. If not, see <http://www.gnu.org/licenses/>.

(local lines [])

(each [line (io.lines)]
  (table.insert lines line))

(fn char-at [s i]
  (string.sub s i i))

(fn common-chars* [a b i acc]
  (if (< (# a) i)
    acc
    (let [ai (char-at a i)
          bi (char-at b i)
          new-acc (if (= ai bi)
                      (.. acc ai)
                      acc)]
      (common-chars* a b (+ 1 i) new-acc))))


(fn common-chars [a b]
  (common-chars* a b 1 ""))

(fn delta* [a b i acc]
  (if (< (# a) i)
    acc
    (let [ai (char-at a i)
          bi (char-at b i)
          new-acc (if (~= ai bi)
                      (+ 1 acc)
                      acc)]
     (delta* a b (+ 1 i) new-acc))))

(fn delta [a b]
  (delta* a b 1 0))

(for [i 1 (# lines)]
  (for [j (+ i 1) (# lines)]
    (let [a (. lines i)
          b (. lines j)]
      (when (= 1 (delta a b))
        (print (common-chars a b))))))
