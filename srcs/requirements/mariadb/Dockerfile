# Current oldsatble: Debian 11 Bullseye
FROM debian:oldstable

RUN apt update && apt upgrade -y && apt install mariadb-server -y

COPY tools/startup.sh .

EXPOSE 3306

CMD ["bash", "startup.sh"]