FROM golang:1.11

WORKDIR $GOPATH/src/go-docker

COPY ./app .

# Download all the dependencies
# https://stackoverflow.com/questions/28031603/what-do-three-dots-mean-in-go-command-line-invocations
RUN go get -d -v ./...

# Install the package
RUN go install -v ./...

# This container exposes port 80 to the outside world
EXPOSE 80

# Run the executable
CMD ["go-docker"]