FROM debian:buster
MAINTAINER Alexis BIZON
LABEL 	name="lemonldapNG-portail" \
		version="v2.0"
		
ENV LOGLEVEL=info \
	DEBIAN_FRONTEND=noninteractive
	
EXPOSE 80

COPY entrypoint.sh /

VOLUME ["/etc/lemonldap-ng","/var/lib/lemonldap-ng/conf", "/var/lib/lemonldap-ng/sessions", "/var/lib/lemonldap-ng/psessions"]


ENTRYPOINT ["dumb-init","--","/bin/sh", "/entrypoint.sh"]