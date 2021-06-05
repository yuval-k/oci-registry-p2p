FROM --platform=arm64 golang:1.15-buster as build

WORKDIR /app
ADD ./go.mod ./go.sum /app/

RUN go mod download

ADD ./main.go /app/
ADD registry/ /app/registry/

RUN go build -o /go/bin/app

# Now copy it into our base image.
FROM gcr.io/distroless/base-debian10
COPY --from=build /go/bin/app /
ENTRYPOINT ["/app"]