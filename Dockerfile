FROM jenkins/jenkins:lts

USER root

# Download ArgoCD CLI and install it
RUN curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/v2.7.2/argocd-linux-amd64 && \
    chmod +x /usr/local/bin/argocd

USER jenkins
