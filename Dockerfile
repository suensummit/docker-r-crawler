FROM c3h3/r-nlp:sftp

MAINTAINER Chia-Chi Chang <c3h3.tw@gmail.com>

RUN apt-get update && \
    apt-get install -y libhiredis-dev libssl-dev crontab

ADD package_installer.R /tmp/package_installer.R
RUN cd /tmp && Rscript package_installer.R

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
