source:
  eval $(opam env)

watch:
  dune exec -w bin/main.exe
