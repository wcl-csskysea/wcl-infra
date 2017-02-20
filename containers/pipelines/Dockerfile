FROM boratbot/pipelines

ENV ANSIBLE_VERSION=2.2.1.0

# Add simple support of ansible to pipelines
RUN pip install ansible==$ANSIBLE_VERSION

RUN mkdir /data 
VOLUME /data

# Ensure we have a properly owned .ssh folder so we can save known_hosts
RUN mkdir /home/pipelines/.ssh && \
    chown pipelines. /home/pipelines/.ssh