FROM debian:oldstable

RUN apt update && apt install mariadb-server -y

COPY tools/startup.sh .

EXPOSE 3306

CMD ["bash", "startup.sh"]