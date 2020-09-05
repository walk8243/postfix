# postfix

メールサーバを構築する

## Dockerイメージを使った検証

以下のコマンドで、メールが送受信されていることが確認できます。

```.sh
[host]$ docker build -t walk8243/postfix .
[host]$ docker run -it walk8243/postfix:latest /bin/bash

[root@docker]$ postfix start
[root@docker]$ ls /home/walk8243/
[root@docker]$ echo "test mail." | mailx -s "test" walk8243@walk8243.xyz
[root@docker]$ ls /home/walk8243/
[root@docker]$ su - walk8243

[walk8243@docker]$ mail -f Maildir
```
