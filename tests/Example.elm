module Example exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)

type alias Item =
  { name : String
  , sellIn : Int
  , quality: Int
  }

endOfDay : List Item -> List Item
endOfDay itemList =
    List.map
      (\item ->
        let
          qualityMultiplier =
            if item.name == "Aged Brie" then
              -1
            else
              1
          qualityMinus =
            if item.sellIn <= 0 then
              2
            else
              1
          newQuality =
            if item.name == "Sulfuras" then
              80
            else if (item.quality - (qualityMultiplier * qualityMinus)) > 50 then
              50
            else
              item.quality - (qualityMultiplier * qualityMinus)
          sellIn =
            if item.name == "Sulfuras" then
              item.sellIn
            else
              item.sellIn - 1
        in

        Item item.name sellIn (max 0 newQuality)
      )
      itemList

suite : Test
suite =
    describe "End of day"
    [ test "At the end of each day our system lowers both values for every item" <|
      \_ ->
        let
          givenItems =
            [Item "Thing" 10 10]
          expectedItems =
            [Item "Thing" 9 9]
        in
        Expect.equal expectedItems (endOfDay givenItems)
    , test "Once the sell by date has passed, Quality degrades twice as fast" <|
      \_ ->
        let
          givenItems =
            [Item "Thing" 0 10]
          expectedItems =
            [Item "Thing" -1 8]
        in
        Expect.equal expectedItems (endOfDay givenItems)
    , test "The Quality of an item is never negative" <|
      \_ ->
        let
           givenItems =
             [ Item "Thing" 10 1
             , Item "Thing" 10 0
             ]
           expectedItems =
              [ Item "Thing" 9 0
              , Item "Thing" 9 0
              ]
        in
        Expect.equal expectedItems (endOfDay givenItems)
      , test "\"Aged Brie\" actually increases in Quality the older it gets" <|
        \_ ->
          let
             givenItems =
               [ Item "Aged Brie" 10 10]
             expectedItems =
                [ Item "Aged Brie" 9 11]
          in
          Expect.equal expectedItems (endOfDay givenItems)
      , test "The Quality of an item is never more than 50" <|
        \_ ->
          let
             givenItems =
               [ Item "Thing" 10 55
               , Item "Aged Brie" 10 50
               ]
             expectedItems =
                [ Item "Thing" 9 50
                , Item "Aged Brie" 9 50
                ]
          in
          Expect.equal expectedItems (endOfDay givenItems)
      , test "\"Sulfuras\", being a legendary item, never has to be sold or decreases in Quality" <|
        \_ ->
          let
             givenItems =
               [ Item "Sulfuras" 10 80
               ]
             expectedItems =
                [ Item "Sulfuras" 10 80
                ]
          in
          Expect.equal expectedItems (endOfDay givenItems)
    ]
