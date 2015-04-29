FROM php:5.6-fpm
MAINTAINER Jonas Renggli <jonas.renggli@swisscom.com>

RUN apt-get update \
	&& apt-get install -y \
		graphicsmagick \
		zip \
		unzip \
		wget \
		curl \
		git \
		mysql-client \
		moreutils \
		dnsutils \
	&& rm -rf /var/lib/apt/lists/* 

RUN apt-get update

#RUN docker-php-ext-install json


RUN apt-get update \
	&& apt-get install -y libpng12-dev libjpeg-dev \
	&& docker-php-ext-configure gd --with-jpeg-dir=/usr/lib \
	&& docker-php-ext-install gd

RUN docker-php-ext-install mysqli

RUN apt-get -y install re2c libmcrypt-dev \
	&& docker-php-ext-install mcrypt

#RUN apt-get -y install zlib1g-dev \
#	&& docker-php-ext-install zip

RUN docker-php-ext-install mbstring


RUN buildRequirements="libicu-dev g++" \
    && apt-get update && apt-get install -y ${buildRequirements} \
    && docker-php-ext-install intl \
    && apt-get purge -y ${buildRequirements} \
    && runtimeRequirements="libicu52" \
    && apt-get install -y --auto-remove ${runtimeRequirements} 

#RUN apt-get install -y libcurl4-openssl-dev
#RUN docker-php-ext-install curl

#RUN apt-get install -y zlib1g-dev \
#    && docker-php-ext-install zip \
#    && apt-get purge -y --auto-remove zlib1g-dev

#RUN apt-get update && apt-get install -y \
#        libfreetype6-dev \
#        libjpeg62-turbo-dev \
#        libmcrypt-dev \
#        libpng12-dev \
#    && docker-php-ext-install iconv mcrypt

RUN apt-get install -y libyaml-dev
RUN pecl install yaml
RUN echo "extension=yaml.so" > /usr/local/etc/php/conf.d/ext-yaml.ini

RUN apt-get update && apt-get install -y libmagickwand-6.q16-dev --no-install-recommends \
&& ln -s /usr/lib/x86_64-linux-gnu/ImageMagick-6.8.9/bin-Q16/MagickWand-config /usr/bin \
&& pecl install imagick \
&& echo "extension=imagick.so" > /usr/local/etc/php/conf.d/ext-imagick.ini

RUN docker-php-ext-install opcache

RUN curl -sSL https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && apt-get update \
#    && apt-get install -y zlib1g-dev git \
#    && docker-php-ext-install zip \
#    && apt-get purge -y --auto-remove zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*


RUN docker-php-ext-install pdo_mysql

ADD assets/php.ini /usr/local/etc/php/conf.d/php.ini

ADD assets/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm"]
