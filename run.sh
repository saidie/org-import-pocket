#!/bin/sh

docker run -v $PWD:/app -it pocket-tools bundle exec ruby "$@"
