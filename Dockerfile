FROM circleci/golang:1.9.1

ENV GOPATH /go

RUN go get -u github.com/golang/dep/cmd/dep
RUN sudo apt-get install -y python-pip
RUN sudo pip install awscli
RUN curl -L -o kubectl.tar.gz https://dl.k8s.io/v1.7.9/kubernetes-client-linux-amd64.tar.gz \
  && tar zxvf kubectl.tar.gz \
  && sudo mv kubernetes/client/bin/kubectl /usr/local/bin/kubectl \
  && rm -rf kubernetes kubectl.tar.gz
