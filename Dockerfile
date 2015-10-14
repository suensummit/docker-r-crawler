FROM c3h3/r-nlp:sftp

MAINTAINER Summit Suen <summit.suen@gmail.com>

# Update basic packages
RUN sudo apt-get update && \
    apt-get install -y libhiredis-dev libssl-dev cron vim man

# Set root password
ENV ROOT_PASS="ntu-copens"
ADD set_root_pw.sh /set_root_pw.sh
ADD run.sh /run.sh
RUN chmod +x /*.sh
ENV AUTHORIZED_KEYS **None**
RUN sh /run.sh

# add webupd8 repository
RUN \
    echo "===> add webupd8 repository..."  && \
    echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list  && \
    echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list  && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886  && \
    apt-get update  && \
    \
    \
    echo "===> install Java"  && \
    echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections  && \
    echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections  && \
    DEBIAN_FRONTEND=noninteractive  apt-get install -y --force-yes oracle-java8-installer oracle-java8-set-default  && \
    \
    \
    echo "===> clean up..."  && \
    rm -rf /var/cache/oracle-jdk8-installer  && \
    apt-get clean  && \
    rm -rf /var/lib/apt/lists/*

# Set the timezone.
RUN sudo echo "Asia/Taipei" > /etc/timezone && \
    sudo dpkg-reconfigure -f noninteractive tzdata

# Set required R packages
ADD package_installer.R /tmp/package_installer.R
RUN cd /tmp && Rscript package_installer.R

# Set required Python packages
ADD requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
