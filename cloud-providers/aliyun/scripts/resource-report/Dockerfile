FROM testcab/yay

RUN yay -Syu --noconfirm --needed \
  aliyun-cli \
  jq \
  python-apprise \
  ruby-mustache

COPY . .

ENTRYPOINT ["./generate-and-send-report"]
