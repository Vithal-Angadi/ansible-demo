# Use alpine/ansible as the base image
FROM alpine/ansible:2.18.1

# Update package list and install dependencies
RUN apk update && apk add --no-cache \
    python3 \
    py3-pip \
    openssl \
    curl \
    && python3 -m venv /venv \
    && . /venv/bin/activate \
    && pip install --no-cache-dir ansible kubernetes PyYAML

# Install Helm
RUN curl -fsSL -o /tmp/get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 \
    && chmod +x /tmp/get_helm.sh \
    && /tmp/get_helm.sh \
    && rm -f /tmp/get_helm.sh

# Set PATH to include the virtual environment and helm
ENV PATH="/venv/bin:/usr/local/bin:$PATH"


# Set PATH to include the virtual environment
ENV PATH="/venv/bin:$PATH"



# Install Ansible Galaxy collections for Kubernetes
RUN ansible-galaxy collection install community.kubernetes kubernetes.core

# Copy Ansible playbooks and inventory
COPY playbooks /ansible/playbooks
COPY inventory /ansible/inventory

# Set working directory
WORKDIR /ansible

# Run a test command to check the Ansible version
RUN ansible --version

# command
CMD ["-i","inventory","/ansible/playbooks/playbook.yaml"]
