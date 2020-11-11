port module GTag exposing
    ( load
    , config
    , event
    , login
    , pageView
    , search
    , viewItem
    , viewItemList
    , customEvent
    )


import Json.Encode exposing (Value, bool, list, object, string)


type alias GParams = List ( String, Value )

port gload : { measurementId : String, sendPageView : Bool } -> Cmd msg
port gconfig : { measurementId : String, params : Value } -> Cmd msg
port gevent : { eventName : String, params : Value } -> Cmd msg
port gset : { keyValuePairs : Value } -> Cmd msg


{-| Load Google Analytics gtag.

-}
load : String -> Cmd msg
load measurementId =
    gload { measurementId = measurementId, sendPageView = True }


{-| Allows you to add additional configuration information to
targets. This is typically product-specific configuration for a
product such as Google Ads or Google Analytics.

-}
config : String -> List ( String, Value ) -> Cmd msg
config measurement_id params =
    gconfig { measurementId = measurement_id, params = object params }


{-| Send a recommended or custom event to Google Analytics.

-}
event : String -> GParams -> Cmd msg
event eventName params =
    gevent { eventName = eventName, params = object params }


-- RECOMMENDED EVENTS.


{-| Send this event to signify that a user has logged in.

-}
login : Cmd msg
login =
    event "login" [ ]


{-| This event signifies a user has viewed a page.

-}
pageView : String -> Cmd msg
pageView url =
    event "page_view" [ ( "page_path", string url ) ]


{-| Use this event to contextualize search operations. This event can
help you identify the most popular content in your app.

-}
search : String -> Cmd msg
search searchTerm =
    event "search" [ ( "search_term", string searchTerm ) ]


{-| This event signifies that some content was shown to the user. Use
this event to discover the most popular items viewed.

See [view_item](https://developers.google.com/gtagjs/reference/event#view_item) for more details.
-}
viewItem : String -> String -> List (String, String ) -> Cmd msg
viewItem id name other =
    let
        params =
            ( "id", string id )
            :: ( "name", string name )
            :: List.map (\(key, value) -> (key, string value) ) other
        items = [ ( "items", list object [ params ] ) ]
    in
    event "view_item" items


{-| Log this event when the user has been presented with a list of
items of a certain category.

-}
viewItemList : Cmd msg
viewItemList =
    event "view_item_list" []



-- CUSTOM EVENTS

customEvent : String -> Maybe String -> Maybe String -> Cmd msg
customEvent action category label =
    let
        params =
            ( case category of
                Just c ->
                    [ ( "event_category", string c ) ]
                Nothing ->
                    []
            )
            ++
            ( case label of
                Just l ->
                    [ ( "event_label", string l ) ]
                Nothing ->
                    []
            )
    in
    event action params
