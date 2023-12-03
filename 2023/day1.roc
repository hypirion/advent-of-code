
app "day1"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.7.0/bkGby8jb0tmZYsy2hg1E_B2QrCgcSTxdUlHtETwm5m4.tar.br" }
    imports [
        pf.Stdout,
        pf.Stdin,
        pf.Task.{ Task },
        Util.{allLines, prefixes},
    ]
    provides [main] to pf

main =
    lines <- allLines |> Task.await
    {} <- problem1 lines |> Num.toStr |> Stdout.line |> Task.await
    problem2 lines |> Num.toStr |> Stdout.line

digits = [
    ("1", 1),
    ("2", 2),
    ("3", 3),
    ("4", 4),
    ("5", 5),
    ("6", 6),
    ("7", 7),
    ("8", 8),
    ("9", 9),
  ]

wordDigits = [
    ("one",   1),
    ("two",   2),
    ("three", 3),
    ("four",  4),
    ("five",  5),
    ("six",   6),
    ("seven", 7),
    ("eight", 8),
    ("nine",  9),
  ]


problem1Assoc = digits
problem2Assoc = List.concat digits wordDigits

problem1 : List Str -> Nat
problem1 = \x ->
  solveWith problem1Assoc x

problem2 : List Str -> Nat
problem2 = \x ->
  solveWith problem2Assoc x

solveWith : List (Str, Nat), List Str -> Nat
solveWith = \assoc, xs ->
  List.map xs (\x -> solve1 assoc x) |> List.sum

solve1 : List (Str, Nat), Str -> Nat
solve1 = \assoc, line ->
  results = prefixes line |> List.keepOks (\x -> digitFromPrefix assoc x)
  when (List.first results, List.last results) is
    (Ok a, Ok b) -> a*10 + b
    _ -> 0

digitFromPrefix : List (Str, Nat), Str -> Result Nat [NotFound]
digitFromPrefix = \assoc, prefix ->
  List.walkUntil assoc (Err NotFound) (\_, (k, v) ->
    if Str.startsWith prefix k then
      Break (Ok v)
    else Continue (Err NotFound)
  )
