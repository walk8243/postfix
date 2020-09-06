# postfix

メールサーバを構築する

## Dockerイメージを使った検証

以下のコマンドで、メールが送受信されていることが確認できます。

```.sh
[host]$ docker build -t walk8243/postfix .
[host]$ docker run -it --add-host=walk8243.work:127.0.0.1 walk8243/postfix:latest /bin/bash

[root@docker]$ postfix start
[root@docker]$ ls /home/walk8243/
[root@docker]$ echo "test mail." | mailx -s "test" walk8243@walk8243.work
[root@docker]$ ls /home/walk8243/
[root@docker]$ su - walk8243

[walk8243@docker]$ mail -f Maildir
```

## 複数のDockerコンテナ

```.sh
# dockerAの起動
docker run -d --rm --name=dockerA --net=postfix --add-host=walk8243.work:127.0.0.1 walk8243/postfix:latest
docker exec -it dockerA /bin/bash

# dockerBの起動
docker run -it --rm --name=dockerB --net=postfix --add-host=walk8243.work:172.18.0.2 walk8243/postfix:latest /bin/bash

[root@dockerA ~]$ ls /home/walk8243/
[root@dockerA ~]$ echo "test mail." | mailx -s "test" walk8243@walk8243.work
[root@dockerA ~]$ ls /home/walk8243/
[root@dockerA ~]$ su - walk8243
[walk8243@dockerA ~]$ mail -f Maildir
# ちゃんとメールが届いていることが確認できる
# またこのときFromが `root@walk8243.work` になっていることに注目

[root@dockerB ~]$ sed -i "s/myhostname = walk8243.work/myhostname = walk8243.xyz/" /etc/postfix/main.cf
[root@dockerB ~]$ sh start.sh
[root@dockerB ~]$ ls /home/walk8243/
[root@dockerB ~]$ echo "test mail." | mailx -s "test" walk8243@walk8243.xyz
[root@dockerB ~]$ ls /home/walk8243/
[root@dockerB ~]$ cat /home/walk8243/Maildir/new/*
[root@dockerB ~]$ echo -e "From other container.\ntest mail." | mailx -s "test" walk8243@walk8243.work
[root@dockerB ~]$ ls
# もしちゃんと届いていなければMaildirフォルダができている
# その場合送信エラーになったことを知らせるメールが入っている

[walk8243@dockerA ~]$ mail -f Maildir
# ちゃんとメールが届いていることが確認できる
# またこのときFromが `root@walk8243.xyz` になっていることに注目
```
