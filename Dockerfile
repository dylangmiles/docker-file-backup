FROM debian:bookworm
MAINTAINER	Dylan Miles <dylan.g.miles@gmail.com>

ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM" > /log

# install required packages
RUN		apt-get update -qq && \
		apt-get install -y \
					curl \
					wget && \
          apt-get clean autoclean && \
          apt-get autoremove --yes && \
          rm -rf /var/lib/{apt,dpkg,cache,log}/

ENV		GO_CRON_VERSION v0.0.10

RUN if [ "$TARGETPLATFORM" = "linux/arm64" ] ; then \
	curl -L https://github.com/prodrigestivill/go-cron/releases/download/v0.0.10/go-cron-linux-arm64.gz \
	| zcat > /usr/local/bin/go-cron \
	&& chmod u+x /usr/local/bin/go-cron; \
	fi

RUN if [ "$TARGETPLATFORM" = "linux/amd64" ] ; then \
	curl -L https://github.com/prodrigestivill/go-cron/releases/download/v0.0.10/go-cron-linux-amd64.gz \
	| zcat > /usr/local/bin/go-cron \
	&& chmod u+x /usr/local/bin/go-cron; \
	fi

# install backup scripts
ADD		backup-file.sh /usr/local/sbin/backup-file.sh
ADD		backup-run.sh /usr/local/sbin/backup-run.sh

#18080 http status port
EXPOSE		18080

ADD		docker-entrypoint.sh /usr/local/sbin/docker-entrypoint.sh
ENTRYPOINT	["/usr/local/sbin/docker-entrypoint.sh"]

CMD		["go-cron"]
