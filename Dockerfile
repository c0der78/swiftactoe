FROM swift:bionic as builder

WORKDIR /src/

COPY . /src

RUN swift build

FROM ubuntu:bionic 

COPY --from=builder /src/.build/SwifTacToe /bin/

ENTRYPOINT /bin/SwifTacToe

