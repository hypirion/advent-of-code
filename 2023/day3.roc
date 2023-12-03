app "day2"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.7.0/bkGby8jb0tmZYsy2hg1E_B2QrCgcSTxdUlHtETwm5m4.tar.br" }
    imports [
        pf.Stdout,
        pf.Stdin,
        pf.Task.{ Task },
        Util.{allLines},
    ]
    provides [main] to pf

main =
  lines <- allLines |> Task.await
  schematic = walkGrid lines
  {} <- part1 schematic |> Num.toStr |> Stdout.line |> Task.await
  part2 schematic |> Num.toStr |> Stdout.line

Loc : {y: I64, x: I64}
Symbol : { id: U8, loc: Loc }
Number : { val : I64, bbox: BBox }
BBox: {y1 : I64, x1: I64, y2: I64, x2: I64}
Schematic : {syms: List Symbol, nums: List Number}

part1 : Schematic -> I64
part1 = \sc ->
  List.keepIf sc.nums (\num ->
    List.any sc.syms (\sym -> adjacent num.bbox sym.loc)
  ) |> List.map .val |> List.sum

part2: Schematic -> I64
part2 = \sc ->
  List.keepIf sc.syms (\s -> s.id == utf8Cog) |>
  List.map (\cog ->
    adjacentNums = List.keepIf sc.nums (\num -> adjacent num.bbox cog.loc)
    if List.len adjacentNums == 2 then
      List.product (List.map adjacentNums .val)
    else
      0
  ) |> List.sum


expandBBox: BBox, I64 -> BBox
expandBBox = \bbox, margin ->
  {y1: bbox.y1 - margin, x1: bbox.x1 - margin,
   y2: bbox.y2 + margin, x2: bbox.x2 + margin}

insideBBox: BBox, Loc -> Bool
insideBBox = \bbox, loc ->
  bbox.y1 <= loc.y && loc.y <= bbox.y2 &&
  bbox.x1 <= loc.x && loc.x <= bbox.x2

# not really adjacent, because this also includes overlaps, but works for
# this problem because nothing overlaps
adjacent: BBox, Loc -> Bool
adjacent = \bbox, loc ->
  expanded = expandBBox bbox 1
  insideBBox expanded loc

## Parsing part

WalkNum : [None, Partial {x1: I64, y1: I64, val: I64}]
appendDigit : WalkNum, I64, I64, I64 -> WalkNum
appendDigit = \wn, y, x, d ->
  when wn is
    None -> Partial {x1: x, y1: y, val: d}
    Partial p -> Partial {p & val: p.val*10 + d}

finaliseNum : WalkNum -> Result Number [NoNumber]
finaliseNum = \wn ->
  when wn is
    None -> Err NoNumber
    Partial p -> Ok { val: p.val,
                      bbox: {y1: p.y1, x1: p.x1,
                             y2: p.y1, x2: p.x1 + digitLen(p.val) - 1}}

digitLen : I64 -> I64
digitLen = \n ->
  if n < 10 then
    1
  else 1 + digitLen (n//10)

WalkState : {sc: Schematic, num: WalkNum}
toWalkState : Schematic -> WalkState
toWalkState = \sc -> {sc: sc, num: None}

fromWalkState : WalkState -> Schematic
fromWalkState = \ws ->
  sc = ws.sc
  {sc & nums: List.appendIfOk sc.nums (finaliseNum ws.num)}

appendWalkNum : WalkState -> WalkState
appendWalkNum = \ws ->
  {sc: fromWalkState ws, num: None}

digits = Str.toUtf8 "0123456789"

# Str.toUtf8 ".", "*"
utf8Dot = 46
utf8Cog = 42

charType : U8 -> [Digit I64, Symbol U8, Dot]
charType = \c ->
  when List.findFirstIndex digits (\c2 -> c == c2) is
    Ok d -> Digit (Num.toI64 d)
    _ -> if c == utf8Dot then
           Dot
         else
           Symbol c

walkLine : Schematic, Str, Nat -> Schematic
walkLine = \sc, line, ny ->
  y = Num.toI64 ny
  List.walkWithIndex (Str.toUtf8 line) (toWalkState sc) (
    \ws, ch, x -> when charType ch is
      Digit d -> {ws & num: appendDigit ws.num y (Num.toI64 x) d}
      Symbol s ->
        curSC = ws.sc
        nxtSyms =  List.append curSC.syms {id: s, loc: {y: y, x: (Num.toI64 x)}}
        {ws & sc: {curSC & syms: nxtSyms}} |> appendWalkNum
      Dot -> appendWalkNum ws
  ) |> fromWalkState

walkGrid: List Str -> Schematic
walkGrid = \grid ->
  List.walkWithIndex grid {syms: [], nums: []} walkLine
