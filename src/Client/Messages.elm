module Client.Messages exposing (viewAll)

import Analyser.Checks
import Analyser.Messages.Data as Data
import Analyser.Messages.Grouped as Grouped exposing (GroupedMessages)
import Analyser.Messages.Types exposing (Message, MessageStatus(Fixing, Outdated))
import Dict exposing (Dict)
import Html exposing (Html, a, div, h5, li, p, span, strong, text, ul)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)


labelIndex : Dict String String
labelIndex =
    Analyser.Checks.all
        |> List.map (\k -> ( k.info.key, k.info.name ))
        |> Dict.fromList


viewAll : (Message -> a) -> GroupedMessages -> Html a
viewAll tag messages =
    ul
        [ style
            [ ( "list-style", "none" )
            , ( "padding", "0" )
            ]
        ]
        (Grouped.map (renderGroup tag) messages)


renderGroup : (Message -> msg) -> ( String, List ( String, Message ) ) -> Html msg
renderGroup tag ( title, xs ) =
    div []
        [ h5 [] [ text title ]
        , div []
            (List.indexedMap (\n ( label, message ) -> view tag n label message) xs)
        ]


view : (Message -> a) -> Int -> String -> Message -> Html a
view tag n label message =
    li
        [ style
            [ ( "margin", "10px" )
            , ( "padding", "10px" )
            , ( "border", "1px solid #ccc" )
            , ( "border-radius", "3px" )
            , ( "background"
              , if message.status == Fixing then
                    "#dff0d8"
                else
                    "#fafafa"
              )
            , ( "opacity"
              , if message.status == Outdated then
                    ".5"
                else
                    "1.0"
              )
            ]
        ]
        [ div [ style [ ( "display", "table-row" ) ] ]
            [ a
                [ onClick (tag message)
                , style
                    [ ( "cursor", "pointer" )
                    , ( "display", "table-cell" )
                    , ( "padding-right", "20px" )
                    , ( "font-size", "200%" )
                    , ( "vertical-align", "middle" )
                    ]
                ]
                [ strong []
                    [ text <| (++) "#" <| toString <| n + 1 ]
                ]
            , span [ style [ ( "display", "table-cell" ) ] ]
                [ p [] [ strong [] [ text <| Maybe.withDefault label <| Dict.get label labelIndex ] ]
                , text <| Data.description message.data
                ]
            ]
        ]
