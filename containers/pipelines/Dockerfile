FROM boratbot/pipelines

# Add misc binaries used in some pipelines
RUN apt-get update \
    && apt-get install -y rsync unzip git \
    && rm -rf /var/lib/apt/lists/*

# Add Google tools / k8s
RUN CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" \
    && echo "deb https://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" > /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
    && apt-get update \
    && apt-get install google-cloud-sdk kubectl \
    && rm -rf /var/lib/apt/lists/*

# Add simple support of ansible to pipelines
ENV ANSIBLE_VERSION=2.3.0.0
RUN pip install ansible==$ANSIBLE_VERSION

RUN mkdir /data 
VOLUME /data

# Ensure we have a properly owned .ssh folder so we can save known_hosts
# And the same for k8s and gcloud config folders
RUN mkdir /home/pipelines/{.ssh,.kube,.config} && \
    chown pipelines. -R /home/pipelines
