FROM homebrew/brew:3.3.16

RUN brew install aliyun-cli

RUN sudo apt-get update \
  && sudo apt-get install -y jq ruby-mustache \
  && sudo rm -rf /var/lib/apt/lists/*

COPY . .

ENTRYPOINT ["./generate-report"]
