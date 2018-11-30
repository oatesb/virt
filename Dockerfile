FROM oraclelinux:7-slim
RUN yum -y update && \
	yum install -y ntp && \
	yum clean all

COPY ./ntp.conf /etc/ntp.conf

#See if we can remove --cap-add='SYS_TIME' -- there might be no way around
#The container gets its time from the pool and serves it.
#
#What it is we expect from the host?
#A- To get its time from the container using NTP (and other services/containers hosted elsewhere)
#B- To have its time directly set by the container
#
#yes it should be a client like all others

# need to vet these commandlines still.
LABEL RUN="docker run -d --cap-add SYS_NICE --name NAME IMAGE" \
      STOP="docker stop NAME" \
      name="ntpd daemon"

ENTRYPOINT ["/usr/sbin/ntpd"]
# need to vet these commandlines still.
# -n for Foreground -- good
# -N for elevated priority (with SYS_NICE) -- good
# -g for accepting a large skew at startup
# -l for logging to stdout
CMD ["-N", "-n", "-g", "-l", "stdout"]

EXPOSE 123/udp

# let docker know how to test container health
#HEALTHCHECK CMD ntpstat || exit 1

# need to install monitoring still.  Should be a seperate deploy / module / sidecar
