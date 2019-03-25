FROM centos

#ユーザ周りの設定
## ROOTにパスワードをセット
RUN echo 'root:newpassword' |chpasswd

## ユーザを作成
RUN useradd newer
RUN echo 'newer:passpass' |chpasswd
RUN echo "newer    ALL=(ALL)       ALL" >> /etc/sudoers

#yum関連
##リポジトリ追加
###epel
RUN yum install -y epel-release
COPY ./epel.repo /etc/yum.repos.d/epel.repo
###remi
RUN rpm --import http://rpms.famillecollet.com/RPM-GPG-KEY-remi
RUN rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm

## インストール済みのパッケージをアップデート＆キャッシュのクリア
RUN yum -y update && yum clean all

## sudoのインストール
RUN yum install -y sudo
