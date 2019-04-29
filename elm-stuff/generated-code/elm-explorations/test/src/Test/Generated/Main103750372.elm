module Test.Generated.Main103750372 exposing (main)

import Example

import Test.Reporter.Reporter exposing (Report(..))
import Console.Text exposing (UseColor(..))
import Test.Runner.Node
import Test

main : Test.Runner.Node.TestProgram
main =
    [     Test.describe "Example" [Example.suite] ]
        |> Test.concat
        |> Test.Runner.Node.run { runs = Nothing, report = (ConsoleReport UseColor), seed = 79630312493389, processes = 4, paths = ["/Users/kangsheng/Developer/elm/gildedrose-refactoring-kata/tests/Example.elm"]}