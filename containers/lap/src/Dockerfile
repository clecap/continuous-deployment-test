FROM alpine:3.15

LABEL "vendor"="Clemens H. Cap"
LABEL "maintainer"="clemens.cap@uni-rostock.de"

ENV PHP_INI_DIR /etc/php/7.4

RUN apk update;   \
    apk --no-cache upgrade;  \
#   *** PHP    
    apk --no-cache add php7; \
#   *** PHP extensions as required for Mediawiki       
    apk --no-cache add php7-session php7-openssl php7-json  php7-mbstring  php7-fileinfo php7-intl php7-calendar php7-ctype php7-xml php7-xmlreader php7-xmlwriter php7-simplexml php7-curl; \
#   *** Some more PHP extensions as they may seem useful
    apk --no-cache add  php7-bcmath php7-exif php7-ftp php7-dom php7-tokenizer php7-posix php7-iconv; \
#   MYSQL integration for php
    apk --no-cache add php7-mysqli;\
#   *** apcu, igbinary and opcache as needed as suggested by mediawiki optimization    
    apk --no-cache add php7-apcu php7-igbinary php7-opcache;\
#   APACHE integration for php
    apk --no-cache add php7-fpm; \
#   php phar is needed for composer, further down
    apk --no-cache add php-phar; \
#   PEAR will temporarily need a c compiler and a make utility
    apk --no-cache add g++ make; \
#   * PHP UTILITIES:  pear and pecl are needed for installing the DS data type, which we need in Parsifal for cleaning up
    apk --no-cache add php7-dev php-pear; \
#   * honor an explicit request by pecl
    pecl channel-update pecl.php.net;\
#   * install ds
    pecl install ds; \
#   * utilities we need at different places    
    apk --no-cache add wget curl;\
#   * enable proper https resolution for apache
    apk --no-cache add ca-certificates;\ 
#   Needed for syntax highlighting mechanisms    
    apk --no-cache add python3; \
#   Mediawiki needs php dependency tool composer
#   this is a bit tricky and only this helped: https://stackoverflow.com/questions/51443557/how-to-install-php-composer-inside-a-docker-container
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer; \
#   * APACHE
    apk --no-cache add apache2; \
#   requirement for http2
    apk --no-cache add nghttp2-libs apache2-http2; \
#   * APACHE MODULES     
    apk --no-cache add nghttp2 apache2-proxy apache2-ssl;\
#   * diff utils needed for text differences
    apk --no-cache add diffutils; \
#   git needed to get proper hashes in Special:Version and in other places
    apk --no-cache add git;\         
#   THUMBNAIL support in mediawiki
    apk --no-cache add imagemagick php7-gd ; \
#   DJVU support in mediawiki
    apk --no-cache add djvulibre; \
#   netpbm support in mediawiki
    apk --no-cache netpbm ; \       
#   No xpdf in Alpine - using poppler-utils as replacement
    apk --no-cache add poppler-utils; \
#   SVG support in mediawiki
    apk --no-cache add librsvg; \
#   /run/apache2 is pid directory for apache
    mkdir -p /run/apache2;                          \
#   /var/www/html is the html mount point
    mkdir -p /var/www/html;                         \
#   remove remaining alpine container mount point
    rm -Rf /var/www/localhost


COPY httpd.conf                              /etc/apache2/httpd.conf
COPY mediawiki-alpine-lamp-apache2.conf      /etc/apache2/conf.d
COPY mediawiki-alpine-lamp-php.ini           /etc/php7/mediawiki-alpine-lamp-php.ini
COPY ssl.conf                                /etc/apache2/conf.d/ssl.conf
COPY localhost-key.pem                       /etc/ssl/apache2/server.key
COPY localhost.pem                           /etc/ssl/apache2/server.pem
COPY entrypoint.sh                           /



# Expose for http and https
EXPOSE 80
EXPOSE 443

# Expose for nfs 4  TODO: test if this really is necessary
EXPOSE 2049

ENTRYPOINT ["/entrypoint.sh"]