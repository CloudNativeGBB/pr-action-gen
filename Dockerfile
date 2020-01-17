FROM ubuntu:18.04
RUN apt update
RUN apt install -y git
RUN apt install -y curl
RUN apt install -y jq
WORKDIR /usr/src/app

ADD mod-commit-push-pr.sh /mod-commit-push-pr.sh
ENTRYPOINT ["/mod-commit-push-pr.sh"]

