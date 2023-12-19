#!/bin/bash/
 # https://scriptable.com/how-to-install-postgresql-mac-docker/ 

# Pull the postgres image from dockerhub
docker pull postgres
# Create a docker volume to allow persistence of postgres data
docker volume create postgres-data
# Create a container, exposing port 5432, mounting volume
docker run --name postgres-container -e POSTGRES_PASSWORD=mysecretpassword -p 5432:5432 -v postgres-data:/var/lib/postgresql/data -d postgres


# To connect to psql command line tool:
# docker exec -it postgres-container psql -U postgres
