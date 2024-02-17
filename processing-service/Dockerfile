FROM golang:1.19.3 as builder

WORKDIR /workspace

COPY go.mod go.mod
COPY main.go main.go

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on go build -a -o processing-service main.go

FROM alpine:3.15.0
WORKDIR /
COPY --from=builder /workspace/processing-service .
USER 65532:65532

ENTRYPOINT ["/processing-service"]
