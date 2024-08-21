FROM jenkins/jenkins:lts

# Root kullanıcısı olarak çalış
USER root

# Docker'ı ve gerekli bağımlılıkları yükle
RUN apt-get update && \
    apt-get install -y \
    docker.io \
    sudo \
    curl \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Docker grubunu kontrol et ve Jenkins kullanıcısını bu gruba ekle
RUN if ! getent group docker > /dev/null; then groupadd docker; fi && \
    usermod -aG docker jenkins

# ArgoCD CLI'yi yükle
RUN curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/v2.7.2/argocd-linux-amd64 && \
    chmod +x /usr/local/bin/argocd

# Jenkins kullanıcısına geri dön
USER jenkins

# Docker'ın Jenkins tarafından doğru çalışması için gerekli ortam değişkenlerini ayarla
ENV DOCKER_TLS_CERTDIR=/certs

# Varsayılan komutu belirt
CMD ["bash", "-c", "jenkins.sh"]
