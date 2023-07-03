open Dream_html
open Tag
open Attr
open Hx

let index children =
  html [lang "en"] [
    head [] [
      comment "unocss";
      script [src "https://cdn.jsdelivr.net/npm/@unocss/runtime/uno.global.js"] "";
      link [rel "stylesheet"; href "https://cdn.jsdelivr.net/npm/@unocss/reset/tailwind.min.css"];

      comment "custom style";
      link [rel "stylesheet"; href "/static/style.css"];

      comment "htmx and hyperscript";
      script [src "https://unpkg.com/hyperscript.org@0.9.9"] "";
      script [src "https://unpkg.com/htmx.org@1.9.2"; integrity "sha384-L6OqL9pRWyyFU3+/bjdSri+iIphTN/bvYyM37tICVyOJkWZLpP2vGn6VUEXgzg6h"; crossorigin `anonymous] "";
    ];
    body [] children
  ]
;;

let hello who =
  index [
    div [class_ ""] [
      p [__ "on click toggle .bg-yellow on me"] [txt "hello %s" who];
    ]
  ]
;;

let () = 
  Dream.run 
  @@ Dream.logger
  @@ Dream.router [
    Dream.get "/" 
      (fun _ ->
        Dream_html.respond @@ hello "world");

    Dream.get "/:word"
      (fun request ->
        Dream_html.respond @@ hello (Dream.param request "word"));

    Dream.get "/static/**" (Dream.static "./static/")
  ]
;;
