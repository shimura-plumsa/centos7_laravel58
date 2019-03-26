FROM centos

#ユーザ周りの設定
## ROOTにパスワードをセット
RUN echo 'root:newpassword' |chpasswd

## ユーザを作成
RUN useradd newer
RUN echo 'newer:passpass' |chpasswd
RUN echo "newer    ALL=(ALL)       ALL" >> /etc/sudoers

#ミドルウェア、パッケージのインストール（主にyum）

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

## httpdのインストール（apache）
RUN yum install -y httpd

## mariadbのインストール
RUN yum install -y mariadb mariadb-devel mariadb-server

## gitのインストール
RUN yum install -y git

## php関連パッケのインストール
RUN yum --enablerepo=epel install -y libmcrypt.x86_64 libpng-devel.x86_64
RUN yum install -y http://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/l/libraqm-0.1.1-1.el7.x86_64.rpm
RUN yum install -y wget
RUN wget http://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/l/libargon2-20161029-2.el7.x86_64.rpm
RUN rpm -Uvh libargon2-20161029-2.el7.x86_64.rpm

## PHPのインストール
### 本体（php7.2） ＆ Laravel5.8要件 & その他 
RUN yum install -y --enablerepo=remi --enablerepo=remi-php72 php php-cli php-common php-pear php-devel php-gd php-imagick php-mcrypt php-mysqlnd php-opcache openssl-devel php-pdo php-mbstring php-tokenizer php-xml php-ctype php-json php-bcmath

## compoerインストール
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

## node, npm, yarn
RUN yum install -y nodejs npm --enablerepo=epel
RUN npm install -g n
RUN n latest
RUN npm update -g
RUN npm install -g yarn
