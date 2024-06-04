FROM debian:buster-slim AS base
LABEL maintainer="Muhammad Febrian Ardiansyah <ardi@sismedika.com>"
WORKDIR /app

ARG TZ_ARG

# CERT PACKAGES
RUN apt-get update
RUN apt-get install -y ca-certificates

RUN apt-get update && \
    apt-get install -yq tzdata && \
    ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata
ENV TZ=$TZ_ARG

# use golang:1.20 as the base image
FROM golang:1.20-alpine as gobuild

# prepare the working directory
WORKDIR /go/src/github.com/developersismedika/golang-api-template

ARG GO_MACHINE
ARG GO_MODULES_USER
ARG GO_MODULES_PERSONAL_ACCESS_TOKEN

RUN apk update && \
    apk add --no-cache git ca-certificates tzdata gcc libc-dev openssh-client && \
    update-ca-certificates

# RUN go env -w GOPRIVATE="github.com/ardihikaru/sismedika-go-modules" && \
#     echo -e "machine ${GO_MACHINE}\nlogin ${GO_MODULES_USER}\npassword ${GO_MODULES_PERSONAL_ACCESS_TOKEN}" > ~/.netrc

# copy go.mod dan go.sum files to the container
COPY go.mod go.sum ./

# add codes
ADD internal ./internal
ADD cmd/api ./cmd/api

# download dependency
RUN go mod download

# build the executable binary
RUN CGO_ENABLED=0 GOOS=linux go build -o api-service \
    -ldflags "-X main.Version=$VERSION" \
    github.com/developersismedika/golang-api-template/cmd/api

# use distroless as the base image to host the executable binary file (the app)
FROM base AS release

# copy the binary file from the previous build
COPY --from=gobuild /go/src/github.com/developersismedika/golang-api-template/api-service .

# set the executable binary file as the entrypoint from the container
ENTRYPOINT ["/app/api-service"]
