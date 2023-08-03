open Dream_html;;
open Attr;;
open Tag;;
open Hx;;

let index children =
  html [] [
    head [] [
      comment "unocss";
      script [src "https://cdn.jsdelivr.net/npm/@unocss/runtime/uno.global.js"] "";
      link [rel "stylesheet"; href "https://cdn.jsdelivr.net/npm/@unocss/reset/tailwind.min.css"];

      comment "icons";
      script [src"https://code.iconify.design/3/3.1.0/iconify.min.js"] "";

      comment "custom style";
      style [] "
        [un-cloak] {
          display: none;
        }

        svg {
          display: inline-block;
        }
      ";

      comment "htmx and hyperscript";
      script [src "https://unpkg.com/hyperscript.org@0"] "";
      script [src "https://unpkg.com/htmx.org@latest"] "";
      script [src "https://unpkg.com/htmx.org@latest/dist/ext/alpine-morph.js"] "";

      comment "alpinejs";
      script [defer; src "https://unpkg.com/@alpinejs/morph@3.x.x/dist/cdn.min.js"] "";
      script [defer; src "https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"] "";
    ];
    body [attr "un-cloak"] children
  ]
;;

let number_button value =
  button [class_ "p-2 rounded w-[90%%] max-h-[90%%] border hover:bg-gray-100 m-auto"; type_ "button"; string_attr "x-on:click" "input = input + '%d'" value] [txt "%d" value]
;;

let action_button value =
  button [class_ "p-2 rounded w-24 h-24 border m-auto"; type_ "button"; string_attr "x-on:click" "input = input + ' %s '" value] [txt "%s" value]
;;

let calculator input_value =
  div [class_ "relative bg-gradient-to-r from-[#A1FFCE] to-[#FAFFD1] min-h-100dvh";] [
    Tag.form [class_ "absolute bg-white rounded p-10 flex flex-col w-[600px] h-70dvh m-auto inset-0"; post "/calculate"; swap "outerHTML"; string_attr "x-data" "{ input: %s }" input_value] [
      input [class_ "bg-gray-100 c-gray-700 p-2 m-4 text-right w-[100%%]"; string_attr "x-model" "input"; name "input"; id "input"];
      div [class_ "grid grid-cols-3 gap-10"] [
        number_button 1;
        number_button 2;
        number_button 3;
        number_button 4;
        number_button 5;
        number_button 6;
        number_button 7;
        number_button 8;
        number_button 9;
        number_button 0;
      ];
      div [] [
        action_button "+";
        action_button "-";
        action_button "x";
        action_button "/";
        button [] [txt "="];
        button [type_ "button"; string_attr "x-on:click" "input = ''"] [txt "cls"];
        span [class_ "iconify"; string_attr "data-icon" "carbon:bat"] [];
      ]
    ];
  ];
;;

let calculate input =
  let input = String.trim input in
  let input = String.split_on_char ' ' input in
  let rec aux acc = function
    | [] -> acc
    | "+" :: x :: xs -> aux (acc + int_of_string x) xs
    | "-" :: x :: xs -> aux (acc - int_of_string x) xs
    | "x" :: x :: xs -> aux (acc * int_of_string x) xs
    | "/" :: x :: xs -> aux (acc / int_of_string x) xs
    | x :: xs -> aux (int_of_string x) xs
  in
  let result = aux 0 input in
  calculator (string_of_int result)
;;

let () = 
  Dream.run 
  @@ Dream.logger
  @@ Dream.router [
    Dream.get "/" 
      (fun _ ->
        Dream_html.respond @@ index [calculator "''"]);

    Dream.post "/calculate"
      (fun request ->
        match%lwt Dream.form ~csrf:false request with
        | `Ok ["input", input] -> Dream_html.respond @@ calculate input
        |  _ -> Dream.empty `Bad_Request);
  ]
;;
