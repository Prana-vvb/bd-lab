ARG username="pes2ug23cs928"

FROM ubuntu:22.04

ARG username

ENV username=${username}
ENV DEBIAN_FRONTEND=noninteractive
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV HADOOP_HOME=/home/${username}/hadoop-3.3.6
ENV FLUME_HOME=/home/${username}/flume
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$FLUME_HOME/bin

RUN apt-get update && apt-get install -y \
    sudo \
    git \
    unzip \
    neovim \
    openjdk-8-jdk \
    openssh-server \
    openssh-client \
    gettext-base && \
    rm -rf /var/lib/apt/lists/*

RUN ssh-keygen -A
RUN useradd --create-home --shell /bin/bash -G users,sudo ${username} && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh

USER ${username}
WORKDIR /home/${username}

RUN mkdir -p tmpdata dfsdata/datanode dfsdata/namenode .scripts Desktop

ADD --chown=${username}:${username} ./installers/*.tar.gz /home/${username}/

RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys

COPY --chown=${username}:${username} ./config/.hadoop_paths ./config/.bashrc /home/${username}/

COPY --chown=${username}:${username} \
    ./config/hadoop-env.sh \
    ./config/core-site.xml.temp \
    ./config/hdfs-site.xml.temp \
    ./config/mapred-site.xml \
    ./config/yarn-site.xml \
    ${HADOOP_HOME}/etc/hadoop/
RUN envsubst < ${HADOOP_HOME}/etc/hadoop/core-site.xml.temp > ${HADOOP_HOME}/etc/hadoop/core-site.xml && \
    envsubst < ${HADOOP_HOME}/etc/hadoop/hdfs-site.xml.temp > ${HADOOP_HOME}/etc/hadoop/hdfs-site.xml && \
    rm ${HADOOP_HOME}/etc/hadoop/*.temp

COPY --chown=${username}:${username} ./installers/*.sh .scripts/
RUN chmod +x .scripts/*.sh && \
    ./.scripts/all.sh

COPY --chown=${username}:${username} ./config/flume-conf* ${FLUME_HOME}/conf/
RUN envsubst < ${FLUME_HOME}/conf/flume-conf_local > ${FLUME_HOME}/conf/flume-conf-local.properties && \
    envsubst < ${FLUME_HOME}/conf/flume-conf_hdfs > ${FLUME_HOME}/conf/flume-conf-hdfs.properties && \
    rm ${FLUME_HOME}/conf/flume-conf_*

RUN hdfs namenode -format

EXPOSE 9870 9864 8088 8032 9000 22

ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]
