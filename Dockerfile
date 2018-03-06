FROM circleci/golang:1.9.1

USER root

ENV GOPATH /go

RUN go get -u github.com/golang/dep/cmd/dep
RUN sudo apt-get update \
  && sudo apt-get install -y python-pip lsb-release \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
RUN sudo pip install awscli
RUN curl -L -o kubectl.tar.gz https://dl.k8s.io/v1.7.9/kubernetes-client-linux-amd64.tar.gz \
  && tar zxvf kubectl.tar.gz \
  && sudo mv kubernetes/client/bin/kubectl /usr/local/bin/kubectl \
  && rm -rf kubernetes kubectl.tar.gz

ENV HELM_VERSION v2.8.1
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

RUN helm plugin install https://github.com/futuresimple/helm-secrets

RUN curl -Lo /tmp/sops https://github.com/mozilla/sops/releases/download/3.0.2/sops-3.0.2.linux \
  && sudo mv /tmp/sops /bin/sops \
  && rm -rf /tmp/*

RUN mkdir temp \
  && curl -sL https://github.com/aktau/github-release/releases/download/v0.7.2/linux-amd64-github-release.tar.bz2 \
  | tar -xjC temp \
  && mv temp/bin/linux/amd64/github-release /usr/local/bin \
  && rm -rf temp

# "CLI for GitHub Deployments"
RUN go get -u github.com/remind101/deploy/cmd/deploy

# "Deploy Kubernetes Helm Charts"
RUN go get -u github.com/roboll/helmfile

# Verify all the commands to be callable

RUN helm version --client \
  && deploy -h \
  && github-release -h \
  && dep version
