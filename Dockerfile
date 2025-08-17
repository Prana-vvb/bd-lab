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
    neovim \
    openjdk-8-jdk \
    openssh-server \
    openssh-client \
    gettext-base && \
    rm -rf /var/lib/apt/lists/*

RUN ssh-keygen -A
RUN useradd --create-home --shell /bin/bash -G users,sudo ${username} && \
    yes ${password} | passwd ${username}

COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh

USER ${username}
WORKDIR /home/${username}

RUN curl https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz -o hadoop-3.3.6.tar.gz && \
    tar xzf hadoop-3.3.6.tar.gz && rm hadoop-3.3.6.tar.gz

RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys

RUN mkdir -p tmpdata dfsdata/datanode dfsdata/namenode

COPY --chown=${username}:${username} ./config/bashrc.temp /home/${username}/.bashrc.temp
RUN envsubst < /home/${username}/.bashrc.temp > /home/${username}/.bashrc && \
    rm /home/$username/.bashrc.temp

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

EXPOSE 9870 9864 9000 8088 22

ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]
