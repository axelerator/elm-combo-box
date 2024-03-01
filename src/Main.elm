module Main exposing (main)

import Browser
import ComboBox
import Html exposing (Html, a, div, h1, text)
import Html.Events exposing (onClick)


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type alias Model =
    { combo1 : ComboBox.Model
    , combo2 : ComboBox.Model
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { combo1 = ComboBox.init []
      , combo2 = ComboBox.init []
      }
    , Cmd.none
    )


type Msg
    = ForCombo ComboBoxInstance ComboBox.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ForCombo Combo1 cMsg ->
            ( { model | combo1 = ComboBox.update combo1Cfg cMsg model.combo1 }
            , Cmd.none
            )

        ForCombo Combo2 cMsg ->
            ( { model | combo2 = ComboBox.update combo2Cfg cMsg model.combo2 }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


combo1Cfg : ComboBox.Config
combo1Cfg =
    { multi = False
    , options = [ { label = "foo", id = "foo" }, { label = "bar", id = "bar" } ]
    , viewSuggestion = viewSuggestion
    , viewSelected = viewSelected
    }


combo2Cfg : ComboBox.Config
combo2Cfg =
    { multi = True
    , options = [ { label = "Apple 9000", id = "apple" }, { label = "banana", id = "banana" } ]
    , viewSuggestion = viewSuggestion
    , viewSelected = viewSelected
    }


viewSuggestion : msg -> String -> Html msg
viewSuggestion msg label =
    div [] [ a [ onClick msg ] [ text label ] ]


viewSelected : msg -> String -> Html msg
viewSelected msg label =
    div [] [ a [ onClick msg ] [ text "✅", text label ] ]


type ComboBoxInstance
    = Combo1
    | Combo2


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "box 1" ]
        , Html.map (ForCombo Combo1) <| ComboBox.view combo1Cfg model.combo1
        , h1 [] [ text "box 2" ]
        , Html.map (ForCombo Combo2) <| ComboBox.view combo2Cfg model.combo2
        ]
