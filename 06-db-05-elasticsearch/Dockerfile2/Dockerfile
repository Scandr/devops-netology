FROM xillah/06-db-05-elasticsearch:v1 
WORKDIR /opt/elasticsearch-8.6.2/
USER elastic

# Can be done like that but since we have to use free low speed VPN to download this huge file it is better to just copy it from host every time we want to rebuild the image or make another one
# ADD --checksum=4c5ea98af53861d6c7f06f855f3bd4f4f52136d8149347e43f633a23ba56d3237f6ff7346bf849090f4e52b28fc21c98df8d9b0f0f845a330834367705cd366a https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.6.2-linux-x86_64.tar.gz /opt/elasticsearch-8.6.2-linux-x86_64.tar.gz
#ADD ./elasticsearch-8.6.2 /opt/elasticsearch-8.6.2
#RUN tar -xzf elasticsearch-8.6.2-linux-x86_64.tar.gz -C /opt/
#ADD ./elasticsearch.yml /opt/elasticsearch-8.6.2/config/elasticsearch.yml
#RUN echo "ES_HOME=/opt/elasticsearch-8.6.2/" >> /etc/environment && \
#useradd elastic && \
#mkdir /var/lib/es-data && \
#mkdir /var/lib/es-logs && \
#chown -R elastic:elastic /opt/elasticsearch-8.6.2 && \
#chown -R elastic:elastic /var/lib/es-data && \
#chown -R elastic:elastic /var/lib/es-logs
#CMD su elastic && /opt/elasticsearch-8.6.2/bin/elasticsearch -d -p pid
#CMD /opt/elasticsearch-8.6.2/bin/elasticsearch -d -p pid && /bin/bash  
CMD /opt/elasticsearch-8.6.2/bin/elasticsearch  

EXPOSE 9200
