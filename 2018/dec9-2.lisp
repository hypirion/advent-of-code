#!/usr/bin/sbcl --script

;; Or use your own favourite Common Lisp implementation.

;; A program to compute Advent Of Code, problem 9-2 2018.
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

(defun spacep (x)
  (char= x #\Space))

(defun split (s)
  (loop for loc = (position-if-not #'spacep s)
    then (position-if-not #'spacep s :start (1+ end))
    for end = (and loc (position-if #'spacep s :start loc))
    when loc
    collect (subseq s loc end)
    while end))

(defvar *input*
  (loop for elt in (split (read-line))
        for i = (parse-integer elt :junk-allowed t)
        when i
        collect i))

(defvar *player-count* (car *input*))
(defvar *players* (make-array *player-count* :initial-element 0))
(defvar *last-marble* (* 100 (cadr *input*)))

;; doubly-linked list implementation
;; Still not big enough that I care to derive the mathematical formula for this.
(defstruct dll prev val next)
(defun initial-dll (val)
  (let ((dll (make-dll :val val)))
    (setf (dll-prev dll) dll
          (dll-next dll) dll)))

(defun dll-insert-after (dll val)
  (let* ((next (dll-next dll))
         (node (make-dll :prev dll :val val :next next)))
    (setf (dll-prev next) node
          (dll-next dll) node)))

(defun dll-prev-by (dll count)
  (if (zerop count)
      dll
    (dll-prev-by (dll-prev dll) (1- count))))

(defun dll-remove (dll)
  (let* ((next (dll-next dll))
         (prev (dll-prev dll)))
    (setf (dll-next prev) next
          (dll-prev next) prev)
    (values next (dll-val dll))))

(defvar *circle* (initial-dll 0))

(dotimes (i *last-marble*)
  (let ((i (1+ i)))
    (if (zerop (mod i 23))
        (progn
          (setq *circle* (dll-prev-by *circle* 7))
          (incf (svref *players* (mod i *player-count*)) (+ i (dll-val *circle*)))
          (setq *circle* (dll-remove *circle*)))
      (setq *circle* (dll-insert-after (dll-next *circle*) i)))))

(format t "~D~%" (reduce #'max *players*))
