app "day2"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.7.0/bkGby8jb0tmZYsy2hg1E_B2QrCgcSTxdUlHtETwm5m4.tar.br" }
    imports [
        pf.Stdout,
        pf.Stdin,
        pf.Task.{ Task },
        Util.{allLines},
        Num.{max},
    ]
    provides [main] to pf

main =
    lines <- allLines |> Task.await
    optGames = List.mapTry lines parseGame
    when optGames is
      Ok games -> (
          {} <- part1 games |> Num.toStr |> Stdout.line |> Task.await
          part2 games |> Num.toStr |> Stdout.line
      )
      Err _ -> Stdout.line "I messed up"

Game : { id: Nat, sets: List GameSet }
GameSet : {red: Nat, green: Nat, blue: Nat}

parseGame : Str -> Result Game [InvalidNumStr, NotFound, UnknownColour Str]
parseGame = \line ->
    {before: ghead, after: gameSets} <- Str.splitFirst line ": " |> Result.try
    {after: strID}                   <- Str.splitFirst ghead " " |> Result.try
    natID                            <- Str.toNat strID          |> Result.try
    sets <-   List.mapTry (Str.split gameSets "; ") parseGameSet |> Result.try
    Ok {id: natID, sets: sets}

emptySet : GameSet
emptySet = {red: 0, green: 0, blue: 0}

joinSets : GameSet, GameSet -> GameSet
joinSets = \x, y ->
    { red: max x.red y.red,
      green: max x.green y.green,
      blue: max x.blue y.blue }

parseGameSet : Str -> Result GameSet [InvalidNumStr, NotFound, UnknownColour Str]
parseGameSet = \set ->
    subSets <- List.mapTry (Str.split set ", ") (\x ->
      {before: strCount, after: colour} <- Str.splitFirst x " " |> Result.try
      count                             <- Str.toNat strCount   |> Result.try
      when colour is
        "red" ->   Ok {emptySet & red:   count}
        "green" -> Ok {emptySet & green: count}
        "blue" ->  Ok {emptySet & blue:  count}
        _ -> Err (UnknownColour colour)
    ) |> Result.try
    List.walk subSets emptySet joinSets |> Ok


isSubset : GameSet, GameSet -> Bool
isSubset = \x, y ->
  x.red <= y.red && x.green <= y.green && x.blue <= y.blue

elfBag : GameSet
elfBag = {blue: 14, red: 12, green: 13}

part1 : List Game -> Nat
part1 = \games ->
  possibleGames = List.keepIf games (\x -> List.all x.sets
                                           (\set -> isSubset set elfBag))
  List.map possibleGames .id |> List.sum

gameCube : Game -> Nat
gameCube = \game ->
  {red: r, green: g, blue: b} = List.walk game.sets emptySet joinSets
  r*g*b

part2 : List Game -> Nat
part2 = \games ->
  List.map games gameCube |> List.sum