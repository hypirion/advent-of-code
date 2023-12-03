interface Util
    exposes [ prefixes, allLines ]
    imports [
        pf.Stdin,
        pf.Task.{ Task },
    ]

# Something funny's going on inside the Roc runtime:
# https://github.com/roc-lang/roc/issues/6139


prefixes : Str -> List Str
prefixes = \s ->
  lst = Str.graphemes s
  len = List.len lst

  List.range {start: At len, end: At 1} |>
  List.map (\x -> List.takeLast lst x) |>
  List.map (\x -> Str.joinWith x "")

allLines : Task (List Str) *
allLines =
   Task.loop [] (\xs ->
     cur <- Task.await Stdin.line
     when cur is
       Input line -> List.append xs line |> Step |> Task.ok
       End -> Done xs |> Task.ok
   )
