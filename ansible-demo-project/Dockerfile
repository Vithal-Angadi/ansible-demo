# Use alpine/ansible as the base image
FROM python:3.9

# Update package list and install dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    openssl \
    && pip3 install --no-cache-dir ansible kubernetes


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
# Entry point to run Ansible playbooks
ENTRYPOINT ["ansible-playbook"]
