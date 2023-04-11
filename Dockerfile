FROM	debian:jessie
MAINTAINER	Dylan Miles <dylan.g.miles@gmail.com>

# install required packages
RUN		apt-get update -qq && \
		apt-get install -y \
					curl \
					wget && \
          apt-get clean autoclean && \
          apt-get autoremove --yes && \
          rm -rf /var/lib/{apt,dpkg,cache,log}/

ENV		GO_CRON_VERSION v0.0.7

RUN		curl -L https://github.com/odise/go-cron/releases/download/${GO_CRON_VERSION}/go-cron-linux.gz \
		| zcat > /usr/local/bin/go-cron \
		&& chmod u+x /usr/local/bin/go-cron

# install backup scripts
ADD		backup-file.sh /usr/local/bin/backup-file.sh
ADD		backup-run.sh /usr/local/bin/backup-run.sh

#18080 http status port
EXPOSE		18080

ADD		docker-entrypoint.sh /usr/local/sbin/docker-entrypoint.sh
ENTRYPOINT	["/usr/local/sbin/docker-entrypoint.sh"]

CMD		["go-cron"]
