module Example exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)

type alias Item =
  { name : String
  , sellIn : Int
  , quality: Int
  , conjured: Bool
  }

endOfDay : List Item -> List Item
endOfDay itemList =
    List.map
      (\item ->
        let
          qualityMultiplier =
            if item.name == "Aged Brie" || item.name == "Backstage passes" then
              -1
            else
              1
          qualityMinus =
            if (item.sellIn <= 5 && item.name == "Backstage passes") then
              3
            else if item.sellIn <= 0 || (item.sellIn <= 10 && item.name == "Backstage passes") then
              2
            else
              1
          newQuality =
            if item.name == "Sulfuras" then
              80
            else if (item.sellIn <= 0 && item.name == "Backstage passes") then
              0
            else if (item.quality - (qualityMultiplier * qualityMinus)) > 50 then
              50
            else if item.conjured then
              item.quality - 2 * (qualityMultiplier * qualityMinus)
            else
              item.quality - (qualityMultiplier * qualityMinus)
          sellIn =
            if item.name == "Sulfuras" then
              item.sellIn
            else
              item.sellIn - 1
        in

        Item item.name sellIn (max 0 newQuality) item.conjured
      )
      itemList

suite : Test
suite =
    describe "End of day"
    [ test "At the end of each day our system lowers both values for every item" <|
      \_ ->
        let
          givenItems =
            [Item "Thing" 10 10 False]
          expectedItems =
            [Item "Thing" 9 9 False]
        in
        Expect.equal expectedItems (endOfDay givenItems)
    , test "Once the sell by date has passed, Quality degrades twice as fast" <|
      \_ ->
        let
          givenItems =
            [Item "Thing" 0 10 False]
          expectedItems =
            [Item "Thing" -1 8 False]
        in
        Expect.equal expectedItems (endOfDay givenItems)
    , test "The Quality of an item is never negative" <|
      \_ ->
        let
           givenItems =
             [ Item "Thing" 10 1 False
             , Item "Thing" 10 0 False
             ]
           expectedItems =
              [ Item "Thing" 9 0 False
              , Item "Thing" 9 0 False
              ]
        in
        Expect.equal expectedItems (endOfDay givenItems)
      , test "\"Aged Brie\" actually increases in Quality the older it gets" <|
        \_ ->
          let
             givenItems =
               [ Item "Aged Brie" 10 10 False]
             expectedItems =
                [ Item "Aged Brie" 9 11 False]
          in
          Expect.equal expectedItems (endOfDay givenItems)
      , test "The Quality of an item is never more than 50" <|
        \_ ->
          let
             givenItems =
               [ Item "Thing" 10 55 False
               , Item "Aged Brie" 10 50 False
               ]
             expectedItems =
                [ Item "Thing" 9 50 False
                , Item "Aged Brie" 9 50 False
                ]
          in
          Expect.equal expectedItems (endOfDay givenItems)
      , test "\"Sulfuras\", being a legendary item, never has to be sold or decreases in Quality" <|
        \_ ->
          let
             givenItems =
               [ Item "Sulfuras" 10 80 False
               ]
             expectedItems =
                [ Item "Sulfuras" 10 80 False
                ]
          in
          Expect.equal expectedItems (endOfDay givenItems)
      , test "\"Backstage passes\", like aged brie, increases in Quality as its SellIn value approaches" <|
        \_ ->
          let
             givenItems =
               [ Item "Backstage passes" 10 10 False,
                 Item "Backstage passes" 5 10 False,
                 Item "Backstage passes" 0 10 False
               ]
             expectedItems =
                [ Item "Backstage passes" 9 12 False,
                  Item "Backstage passes" 4 13 False,
                  Item "Backstage passes" -1 0 False
                ]
          in
          Expect.equal expectedItems (endOfDay givenItems)
      , test "\"Conjured\" items degrade in Quality twice as fast as normal items" <|
        \_ ->
          let
             givenItems =
               [ Item "Thing" 10 10 True,
                 Item "Aged Brie" 10 10 True,
                 Item "Sulfuras" 10 80 True,
                 Item "Backstage passes" 10 10 True
               ]
             expectedItems =
                [ Item "Thing" 9 8 True,
                  Item "Aged Brie" 9 12 True,
                  Item "Sulfuras" 10 80 True,
                  Item "Backstage passes" 9 14 True
                ]
          in
          Expect.equal expectedItems (endOfDay givenItems)
    ]
