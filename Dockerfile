# Use alpine/ansible as the base image
FROM alpine/ansible:2.18.1

# Install dependencies
RUN apk add --no-cache \
    python3 \
    py3-pip \
    openssl \
    curl \
    && python3 -m venv /venv \
    && . /venv/bin/activate \
    && pip install --no-cache-dir kubernetes PyYAML

# Install Helm
RUN curl -fsSL -o /tmp/get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 \
    && chmod +x /tmp/get_helm.sh \
    && /tmp/get_helm.sh \
    && rm -f /tmp/get_helm.sh

# Set PATH to include virtual environment and Helm
ENV PATH="/venv/bin:/usr/local/bin:$PATH"

# Install Ansible Galaxy collections for Kubernetes
RUN ansible-galaxy collection install community.kubernetes kubernetes.core

# Create a non-root user (ansible) and set permissions
RUN adduser -D -u 1001 ansible \
    && mkdir -p /ansible \
    && chown -R ansible:ansible /ansible /venv

# Switch to non-root user
USER ansible

# Set working directory
WORKDIR /ansible

# Copy Ansible playbooks and inventory as non-root
COPY --chown=ansible:ansible playbooks /ansible/playbooks
COPY --chown=ansible:ansible inventory /ansible/inventory

# Verify installation
RUN ansible --version

# Default command
ENTRYPOINT ["ansible-playbook"]
CMD ["-i", "inventory", "/ansible/playbooks/playbook.yaml"]
