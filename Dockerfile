FROM debian:buster
MAINTAINER Alexis BIZON
LABEL 	name="lemonldapNG-portail" \
		version="v2.0"
		
ENV LOGLEVEL=info \
	DEBIAN_FRONTEND=noninteractive
	
EXPOSE 80

RUN echo "# Install LemonLDAP::NG source repo" && \
    apt-get -y update && \
    apt-get -y install wget apt-transport-https gnupg dumb-init && \
    wget -O - https://lemonldap-ng.org/_media/rpm-gpg-key-ow2 | apt-key add - && \
	echo "deb https://lemonldap-ng.org/deb 2.0 main" >/etc/apt/sources.list.d/lemonldap-ng.list
	
RUN apt-get -y update && \
    echo "# Install LemonLDAP::NG packages" && \
    apt-get -y install nginx lemonldap-ng cron anacron liblasso-perl libio-string-perl lemonldap-ng-fastcgi-server && \
    echo "# Install LemonLDAP::NG TOTP requirements" && \
    apt-get -y install libconvert-base32-perl libdigest-hmac-perl && \
	echo "\ndaemon off;" >> /etc/nginx/nginx.conf
	
RUN echo "# Configure nginx to log to standard streams" && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
	ln -sf /dev/stderr /var/log/nginx/error.log

COPY entrypoint.sh /

VOLUME ["/etc/lemonldap-ng","/var/lib/lemonldap-ng/conf", "/var/lib/lemonldap-ng/sessions", "/var/lib/lemonldap-ng/psessions"]


ENTRYPOINT ["dumb-init","--","/bin/sh", "/entrypoint.sh"]