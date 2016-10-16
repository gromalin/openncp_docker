FROM mysql

EXPOSE 3306

VOLUME /var/lib/mysql

ADD ./startup.sh /opt/startup.sh

CMD ["/bin/bash", "/opt/startup.sh"]

