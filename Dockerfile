FROM centos:centos8

RUN yum install postfix mailx -y
COPY postfix.cf /etc/postfix/main.cf

RUN useradd -m walk8243

RUN sed -i -c -r "s/^(127\.0\.0\.1\s*localhost)$/\1 walk8243/" /etc/hosts && \
	newaliases
