# ProgressReport

日報、技術情報などのレポートを共有しよう。<br>
まわりの人のレポートをみて、その人が成長してると思ったら「成長したね」ボタンを押そう。<br>
みんながどれだけ成長したのか時系列グラフで確認しよう。<br>
<br>
あの人は先月すごい成長したな。<br>
じゃあ、今月は自分もがんばろう。<br>
そんな風に使ってほしい。<br>

# 動作環境

* ruby 2.2.0
* rails 4.2.1

## docker

Apache, Passenger, Postgresql9.3で構成

### イメージをpullする場合

```
docker pull -a itagakishintaro/pr
docker run --privileged -d -p 80:80 --name pr itagakishintaro/pr /sbin/init
```

### Dockerfileをビルドする場合

dockerフォルダ配下をダウンロードして以下を実行

```
docker build -t [YOURNAME]/pr [Dockerfile DIRECTORY]
docker run --privileged -d -p 80:80 --name pr [YOURNAME]/pr /sbin/init
docker exec -it pr /home/pr/run-pr.sh
```

## Heroku

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy?template=https://github.com/itagakishintaro/ProgressReport)

# Licence

商用利用はしないでください。<br>
社内やグループ内での活用は自由です。<br>
そのときは使ってるよと連絡してくれると嬉しいです。<br>
Issueにリクエストや障害報告をしてもらえらたらもっと嬉しいです。<br>
PullRequestやForkをしてもらえたらそんなに嬉しいことはありません。

![Creative Commons License](https://i.creativecommons.org/l/by-nc/4.0/88x31.png)<br>

This work is licensed under a [Creative Commons Attribution-NonCommercial 4.0 International License](http://creativecommons.org/licenses/by-nc/4.0/).
