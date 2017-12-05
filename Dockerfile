FROM circleci/golang:1.9.1

ENV GOPATH /go

RUN go get -u github.com/golang/dep/cmd/dep
RUN sudo apt-get install -y python-pip
RUN sudo pip install awscli
RUN curl -L -o kubectl.tar.gz https://dl.k8s.io/v1.7.9/kubernetes-client-linux-amd64.tar.gz \
  && tar zxvf kubectl.tar.gz \
  && sudo mv kubernetes/client/bin/kubectl /usr/local/bin/kubectl \
  && rm -rf kubernetes kubectl.tar.gz

ENV HELM_VERSION v2.7.2
ENV HELM_FILENAME helm-${HELM_VERSION}-linux-amd64.tar.gz
ENV HELM_URL https://storage.googleapis.com/kubernetes-helm/${HELM_FILENAME}

RUN curl -o /tmp/$HELM_FILENAME ${HELM_URL} \
  && tar -zxvf /tmp/${HELM_FILENAME} -C /tmp \
  && sudo mv /tmp/linux-amd64/helm /bin/helm \
  && rm -rf /tmp/*

# Install Helm plugins
RUN helm init --client-only
# Plugin is downloaded to /tmp, which must exist
RUN helm plugin install https://github.com/databus23/helm-diff
RUN helm plugin install https://github.com/burdiyan/helm-update-config
