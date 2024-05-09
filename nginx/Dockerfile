# L'image de base
FROM nginx:1.25.1

# Les arguments utilisés pendant le build de l'image
ARG MAGENTO_USERNAME
ARG MAGENTO_PASSWORD
ARG MAGENTO_UID

# Définition des variables d'environnement
ENV DEBIAN_FRONTEND=noninteractive
ENV MAGENTO_USERNAME=${MAGENTO_USERNAME}

# Installation des extenions PHP
RUN apt update && \
    apt upgrade -y && \
    apt install -y sudo curl && \
    rm -rf /var/lib/apt/lists/*

# Création de l'utilisateur
RUN useradd -G sudo -u ${MAGENTO_UID} -m ${MAGENTO_USERNAME} \
    && echo "${MAGENTO_USERNAME}:${MAGENTO_PASSWORD}" | chpasswd

# Copie des fichiers de configuration
COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf

# Définition des permissions
RUN chown -R ${MAGENTO_USERNAME}:${MAGENTO_USERNAME} /var/cache/nginx /var/log/nginx /etc/nginx/conf.d /etc/nginx
RUN touch /var/run/nginx.pid && \
    chown ${MAGENTO_USERNAME}:${MAGENTO_USERNAME} /var/run/nginx.pid

# Définition de répertoire de travail
WORKDIR /var/www/html/

# Définition de l'utilisateur
USER ${MAGENTO_USERNAME}

# Bilan de santé
HEALTHCHECK --interval=30s --timeout=3s CMD curl --fail http://localhost/ || exit 1
