FROM golang:1.10.2-alpine3.7
RUN apk update \
  && apk add --no-cache git \
  && go get -u github.com/golang/dep/cmd/dep 
WORKDIR /work/src/github.com/tohutohu/seccamp-b3-fizzbuzz
ENV GOPATH=/work
ADD seccamp-b3-fizzbuzz /work/src/github.com/tohutohu/seccamp-b3-fizzbuzz
RUN dep ensure -v -vendor-only=true
RUN GOOS=linux CGO_ENABLED=0 go build -a -tags netgo -installsuffix netgo --ldflags '-extldflags "-static"' -o app

FROM scratch
COPY --from=0 /work/src/github.com/tohutohu/seccamp-b3-fizzbuzz/app /app
ENTRYPOINT ["/app"]
