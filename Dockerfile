FROM ubuntu:13.10

MAINTAINER Drone.io Team

RUN apt-get update
RUN apt-get install -y wget gcc make g++ build-essential ca-certificates mercurial git bzr libsqlite3-dev sqlite3

RUN wget https://go.googlecode.com/files/go1.2.src.tar.gz && tar zxvf go1.2.src.tar.gz && cd go/src && ./make.bash 

ENV PATH $PATH:/go/bin:/gocode/bin
ENV GOPATH /gocode

RUN mkdir -p /gocode/src/github.com/drone

ADD . /gocode/src/github.com/drone/drone

WORKDIR /gocode/src/github.com/drone/drone

RUN make deps
RUN make
RUN make install

CMD /usr/local/bin/droned --port=:${PORT:-80} --datasource=/var/lib/drone/drone.sqlite