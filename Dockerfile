FROM c3h3/r-nlp:sftp

MAINTAINER Summit Suen <summit.suen@gmail.com>

RUN apt-get update && \
    apt-get install -y libhiredis-dev libssl-dev cron

RUN sudo add-apt-repository ppa:webupd8team/java && \
    sudo apt-get update && \
    sudo apt-get install oracle-java8-installer && \
    java -version

RUN sudo apt-get install oracle-java8-set-default

# Set the timezone.
RUN sudo echo "Asia/Taipei" > /etc/timezone
RUN sudo dpkg-reconfigure -f noninteractive tzdata

ADD package_installer.R /tmp/package_installer.R
RUN cd /tmp && Rscript package_installer.R

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
