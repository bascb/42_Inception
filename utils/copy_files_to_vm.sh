#! /usr/bin/env bash

# Creates variables, with default values
REMOTE_USER="bcastelo" # User to ssh login in remote machine
PASSWORD="" # Remote user password
URL="" # Remote URL

# Define the options using getopt
OPTIONS=$(getopt -o u:p:l: -l url:,password:,remote-login:  -- "$@")

eval set -- "$OPTIONS"

# Process options
while true; do
    case "$1" in
        -u|--url)
            URL=$2
            shift 2
            ;;
        -p|--password)
            PASSWORD=$2
            shift 2
            ;;
        -l|--remote-login)
            REMOTE_USER=$2
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Invalid option"
            exit 1
            ;;
    esac
done

# Check if remote user password was given
if [ "$PASSWORD" == "" ]; then
    echo "Error: Password of remote user not supplied"
    exit
fi

# Check if url was given
if [ "$URL" == "" ]; then
    echo "Error: remote URL not supplied"
    exit
fi

# Copies srcs folder and Makefile
scp -r ../srcs/ $REMOTE_USER@$URL:~/ 

scp ../Makefile $REMOTE_USER@$URL:~/ 

# Copies .env
scp .env $REMOTE_USER@$URL:~/srcs 

# Creates script folder on remote and copies needed scripts
ssh $REMOTE_USER@$URL "mkdir -p /home/$REMOTE_USER/scripts" 

scp install_docker.sh $REMOTE_USER@$URL:~/scripts 

ssh $REMOTE_USER@$URL "chmod +x /home/$REMOTE_USER/scripts/*"
