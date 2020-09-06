FROM centos:centos8

RUN yum install postfix mailx -y
COPY postfix.cf /etc/postfix/main.cf

RUN useradd -m walk8243

RUN newaliases

WORKDIR /root
COPY start.sh .

CMD [ "/bin/sh", "-c", "sh start.sh; while :; do sleep 10; done" ]
