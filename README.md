# swiftactoe

Tic tac toe in swift with networking

## dependencies

- `swift 5.3`
- `nanomsg` or `libnanomsg-dev` on the OS for network

Optional:

- `make` for meta building
- `docker` or `podman`

## build

See `make help`

## debug

Set the log level to `trace`

### networking

Start the host:

`swift run SwifTacToe -s -a ipc:///tmp/pair.ipc 2>host.log`

Join the host:

`swift run SwifTacToe -j -a ipc:///tmp/pair.ipc 2>host.log`

Other addresses:

`-a tcp://191.168.1.XX:7777` for internal TCP network port

`-a ws://example.com:7777` for web socket on external domain port

## demo

![Screenshot](swiftactoe.gif?raw=true "Demo")

## todo

- [x] upgrade swift
- [x] refactor for multiplayer
- [x] finish multiplayer
