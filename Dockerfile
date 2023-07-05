# Start from the official OCaml image
FROM ocaml/opam:2.0.0

# Set up a working directory
WORKDIR /app

# Copy opam configuration files
COPY *.opam* ./

# Install dependencies
RUN sudo apt-get update && sudo apt-get install -y m4 pkg-config
RUN opam install . --deps-only --with-test

# Copy all the source code into the Docker image
COPY . .

# Build the server
RUN dune build @install

# Move to the bin directory where dune installs executables
WORKDIR _build/default

# Set the command to run your application when the docker is run, replace 'my_program' with your program name
CMD ["./main.exe"]

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Copy static files to serve
COPY static /static
