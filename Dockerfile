FROM c3h3/r-nlp:sftp

MAINTAINER Summit Suen <summit.suen@gmail.com>

RUN sudo apt-get update && \
    apt-get install -y libhiredis-dev libssl-dev cron

RUN java -version

RUN sudo su && \
    echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list && \
    echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 && \
    apt-get update && \
    apt-get install oracle-java8-installer

RUN sudo update-alternatives --config java && \
    java -version

# Set the timezone.
RUN sudo echo "Asia/Taipei" > /etc/timezone
RUN sudo dpkg-reconfigure -f noninteractive tzdata

ADD package_installer.R /tmp/package_installer.R
RUN cd /tmp && Rscript package_installer.R

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
