FROM swift:bionic as builder

RUN apt update

RUN apt install -y libnanomsg-dev

WORKDIR /src/

COPY . /src

RUN swift build --static-swift-stdlib -c release

FROM ubuntu:bionic 

RUN apt update

RUN apt install -y libnanomsg-dev

RUN apt clean autoclean
RUN apt autoremove --yes
RUN rm -rf /var/lib/{apt,dpkg,cache,log}/


COPY --from=builder /src/.build/release/SwifTacToe /bin/

ENTRYPOINT /bin/SwifTacToe

