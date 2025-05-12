module TreeTests exposing (..)

import Expect exposing (Expectation)
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
                            Node { id = "a", name = "", image = "", children = [] }

                        child1 =
                            Node { id = "b", name = "", image = "", children = [] }

                        child2 =
                            Node { id = "c", name = "", image = "", children = [] }

                        child3 =
                            Node { id = "d", name = "", image = "", children = [] }

                        tree_ =
                            tree
                                |> insertAt child1 "a"
                                |> insertAt child2 "a"
                                |> insertAt child3 "c"
                    in
                    Expect.equal True (isEqualTo tree_ <| mkNode "a" [ mkNode "c" [ child3 ], child1 ])
            ]
        , describe "isEqualTo"
            [ test "Two nodes without children are equal if they have the same IDs" <|
                \_ ->
                    let
                        n1 =
                            Node { id = "a", children = [], image = "", name = "" }

                        n2 =
                            Node { id = "a", children = [], image = "", name = "" }
                    in
                    Expect.equal True <| isEqualTo n1 n2
            , test "Two nodes are equal if their children have the same IDs" <|
                \_ ->
                    let
                        c1 =
                            mkNode "b" []

                        n1 =
                            mkNode "a" [ c1 ]

                        n2 =
                            mkNode "a" [ c1 ]
                    in
                    Expect.equal True <| isEqualTo n1 n2
            , test "Two nodes are not equal if their children have different IDs" <|
                \_ ->
                    let
                        c1 =
                            mkNode "b" []

                        c2 =
                            mkNode "d" []

                        n1 =
                            mkNode "a" [ c1 ]

                        n2 =
                            mkNode "a" [ c2 ]
                    in
                    Expect.equal False <| isEqualTo n1 n2
            ]
        ]


mkNode : NodeId -> List Node -> Node
mkNode id children =
    Node { id = id, children = children, image = "", name = "" }
