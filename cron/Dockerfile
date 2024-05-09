# L'image de base
FROM php:8.2-cli

# Les arguments utilisés pendant le build de l'image
ARG MAGENTO_USERNAME
ARG MAGENTO_PASSWORD
ARG MAGENTO_UID

# Définition des variables d'environnement
ENV DEBIAN_FRONTEND=noninteractive
ENV MAGENTO_USERNAME=${MAGENTO_USERNAME}

# Installation des extenions PHP
RUN DEPS="sudo cron curl golang-go mailutils zip unzip libpng-dev libjpeg62-turbo-dev libfreetype6-dev zlib1g-dev libicu-dev libxml2-dev libxslt1-dev libzip-dev" && \
    PHP_MODULES="bcmath gd intl pdo_mysql opcache soap sockets xsl zip" && \
    apt update && \
    apt upgrade -y && \
    apt install -y ${DEPS} && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j$(nproc) ${PHP_MODULES} && \
    rm -rf /var/lib/apt/lists/*

# Configuration de PHP-FPM
RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini && \
    echo 'memory_limit = -1' > /usr/local/etc/php/conf.d/memory_limit.ini && \
    echo 'max_execution_time = 1800' > /usr/local/etc/php/conf.d/max_execution_time.ini && \
    echo 'zlib.output_compression = On' /usr/local/etc/php/conf.d/output_compression.ini

# Configuration de Mailpit
RUN GOBIN=/usr/local/bin go install github.com/mailhog/mhsendmail@latest
RUN echo 'sendmail_path="/usr/local/bin/mhsendmail --smtp-addr=mailpit:1025"' >> /usr/local/etc/php/conf.d/mail.ini

# Création de l'utilisateur
RUN useradd -G sudo -u ${MAGENTO_UID} -m ${MAGENTO_USERNAME} -s /usr/bin/bash && \
    echo "${MAGENTO_USERNAME}:${MAGENTO_PASSWORD}" | chpasswd

# Définition des autorisation sur le dossier
RUN chown ${MAGENTO_USERNAME}:${MAGENTO_USERNAME} /var/www/html

# Configuration de la crontab
COPY magento-cron /etc/cron.d/magento-cron
RUN chmod 644 /etc/cron.d/magento-cron && \
    crontab -u ${MAGENTO_USERNAME} /etc/cron.d/magento-cron

# Définition de répertoire de travail
WORKDIR /var/www/html

# Définition de l'utilisateur
USER root

CMD ["cron", "-f"]
