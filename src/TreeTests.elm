module TreeTests exposing (..)

import Expect exposing (Expectation)
import Set
import Test exposing (..)
import Tree exposing (..)


suite : Test
suite =
    describe "Tree"
        [ describe "insertAt"
            [ test "Should insert at the right location" <|
                \_ ->
                    let
                        tree =
                            Node { id = "a", name = "", image = Nothing, children = [] }

                        child1 =
                            Node { id = "b", name = "", image = Nothing, children = [] }

                        child2 =
                            Node { id = "c", name = "", image = Nothing, children = [] }

                        child3 =
                            Node { id = "d", name = "", image = Nothing, children = [] }

                        tree_ =
                            tree
                                |> insertAt child1 "a"
                                |> insertAt child2 "a"
                                |> insertAt child3 "c"
                    in
                    case tree_ of
                        Node root ->
                            Expect.equalLists
                                (node_ids root.children)
                                (node_ids [ child1, Node { id = "c", name = "", image = Nothing, children = [ child3 ] } ])
            ]
        ]



-- TODO: Implement function to test node equality.
