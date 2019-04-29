module Test.Generated.Main4113575446 exposing (main)

import Example

import Test.Reporter.Reporter exposing (Report(..))
import Console.Text exposing (UseColor(..))
import Test.Runner.Node
import Test

main : Test.Runner.Node.TestProgram
main =
    [     Test.describe "Example" [Example.suite] ]
        |> Test.concat
        |> Test.Runner.Node.run { runs = Nothing, report = (ConsoleReport UseColor), seed = 71641789465791, processes = 4, paths = ["/Users/kangsheng/Developer/elm/gildedrose-refactoring-kata/tests/Example.elm"]}