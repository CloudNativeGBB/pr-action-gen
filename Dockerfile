FROM ubuntu:18.04
RUN apt update
RUN apt install -y git
RUN apt install -y curl
RUN apt install -y jq
WORKDIR /usr/src/app

COPY mod-commit-push-pr.sh ./
RUN chmod a+x mod-commit-push-pr.sh
CMD ["/bin/bash", "./mod-commit-push-pr.sh"]

