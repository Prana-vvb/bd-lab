ARG username="pes2ug23cs928"
ARG password="toor"

FROM ubuntu:22.04

ARG username
ARG password

ENV username=${username}
ENV DEBIAN_FRONTEND=noninteractive
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV HADOOP_HOME=/home/${username}/hadoop-3.3.6
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

RUN apt update && apt upgrade -y
RUN apt install -y \
    sudo \
    curl \
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
    yes ${password} | passwd ${username}
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh

USER ${username}
WORKDIR /home/${username}
RUN mkdir -p tmpdata dfsdata/datanode dfsdata/namenode .scripts

RUN wget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz && \
    tar xzf hadoop-3.3.6.tar.gz && rm hadoop-3.3.6.tar.gz

RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys

COPY --chown=${username}:${username} ./config/hadoop_paths /home/${username}/hadoop_paths
RUN envsubst < /home/${username}/hadoop_paths > /home/${username}/.hadoop_paths && \
    rm /home/$username/hadoop_paths

COPY --chown=${username}:${username} ./config/bashrc /home/${username}/.bashrc

COPY --chown=${username}:${username} \
    ./config/hadoop-env.sh \
    ./config/core-site.xml.temp \
    ./config/hdfs-site.xml.temp \
    ./config/mapred-site.xml \
    ./config/yarn-site.xml \
    ${HADOOP_HOME}/etc/hadoop/
RUN envsubst < ${HADOOP_HOME}/etc/hadoop/core-site.xml.temp > ${HADOOP_HOME}/etc/hadoop/core-site.xml && \
    envsubst < ${HADOOP_HOME}/etc/hadoop/hdfs-site.xml.temp > ${HADOOP_HOME}/etc/hadoop/hdfs-site.xml && \
    rm ${HADOOP_HOME}/etc/hadoop/*.xml.temp

RUN hdfs namenode -format

COPY --chown=${username}:${username} ./installers/hive.sh .scripts/
RUN chmod +x .scripts/hive.sh && ./.scripts/hive.sh

EXPOSE 9870 9864 9000 8088 22

ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]
