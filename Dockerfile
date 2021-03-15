FROM centos:latest


RUN yum update -y && \
yum install httpd -y 

WORKDIR /var/www/html

COPY index.html .

EXPOSE 80

CMD ["/usr/sbin/httpd", "-D" , "FOREGROUND"]


 
