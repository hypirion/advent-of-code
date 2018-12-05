! A program to compute Advent Of Code, problem 4-2 2018.
! Copyright (C) 2018 Jean Niklas L'orange
!
! This program is free software: you can redistribute it and/or modify
! it under the terms of the GNU Affero General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! This program is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU Affero General Public License for more details.
!
! You should have received a copy of the GNU Affero General Public License
! along with this program. If not, see <http://www.gnu.org/licenses/>.

USING: accessors assocs arrays locals kernel io math math.order math.ranges
       math.parser sorting sequences prettyprint regexp ;

IN: dec4-2

TUPLE: event event-type ints ;

: <event-type> ( line -- event-type )
  dup R/ begins shift/ re-contains? [ drop "begins shift" ]
  [ R/ wakes up/ re-contains? [ "wakes up" ] [ "falls asleep" ] if ]
  if ;

: strings>numbers ( str-seq -- int-seq )
  [ string>number ] map ;

: string>numbers ( line -- nums )
  R/ \d+/ all-matching-subseqs strings>numbers ;

:: <event> ( line -- event )
  line <event-type>
  line string>numbers
  event boa ;

: guard-id ( event -- id )
  ints>> 5 swap nth ;

: event-minute ( event -- minute )
  ints>> 4 swap nth ;

:: inc-nth ( n seq -- )
   n seq nth :> cur
   1 cur + n seq set-nth ;

: incr-all ( array from upto -- )
  [a,b) [ over inc-nth ] each drop ;

:: add-slept ( sched guard-id from upto -- )
   guard-id sched at
   [ 60 0 <array> ] unless* :> val
   val from upto incr-all
   val guard-id sched set-at ;

:: process-event ( scheds cur-guard slept-from event -- scheds cur-guard slept-from )
   event event-type>> :> event-type
   event-type "begins shift" = [ scheds event guard-id slept-from ]
   [ event-type "falls asleep" = [ scheds cur-guard event event-minute ]
     [ scheds cur-guard slept-from event event-minute add-slept
       scheds cur-guard f ]
     if ]
   if ;

:: compute-guard-sleep-sched ( events -- schedules )
   H{ } clone f f events [ process-event ] each
   drop drop
   ;

:: max-idx-min ( array -- min idx )
  array supremum
  dup array index ;

:: max-guard-minutes ( scheds -- foo )
   { } scheds [ max-idx-min 3array suffix ] assoc-each ;

: max-guard-minute ( scheds -- minute count guard )
  max-guard-minutes [ 1 swap nth ] supremum-by
  first3 ;

: lines>events ( lines -- events ) [ <event> ] map ;

: sorted-lines ( -- lines ) lines natural-sort ;



: main ( -- ) sorted-lines lines>events compute-guard-sleep-sched
              max-guard-minute nip * . ;

MAIN: main
