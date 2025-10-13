#### Master Adv Dockerfile and Docker Networking - Part 3
```
FROM ‹ basimage >
LABEL Name="Mithran"
WORKDIR /app
ADD < source > ‹destination ›
WORKDIR /code
RUN apt-get update
RUN apt install vim
RUN apt install git
ENTRYPOINT python3 main.py
EXPOSE 8000

--------
COPY (OLD)
 - Source (Local machine) -› Destination (Image)

ADD (NEW)
 - Source (Local machine) -› Destination (Image)
 - https://github.com/myrepo.git -› Destination (Image) (Can give http url as Source)
 - myfiles.tar -› Destination (Image) -› (it extract tar and push to image)

RUN
 - multiple RUN can be in DockerFile
 - RUN will be executed when the image is building

ENTRYPOINT
 - Only once
 - ENTRYPOINT will be executed when the container is created from the Image
 - ENTRYPOINT will be executed 1st

CMD
 - Only once, (Even if there is multiple CMD it will only use the last CMD)
 - CMD will be executed when the container is created from the Image
 - CMD will be executed after the EntryPoint
 - CMD is a default value which can be over-ridden during the "docker run" command
```
#### Interview Questions
```
1. How do you decrease the Docker file size?
Ans: I reduce Docker image size by using lightweight base images like Alpine or Distroless (Blackbox), which are smaller and more efficient than Ubuntu or Debian.

 2. What is the difference between the COPY and ADD commands in a Dockerfile?
Ans: COPY only copies local files into the image.
 ADD can copy files and also extract tar files or download from URLs.

3. Write an sample docker file
Ans:
  FROM ubuntu:latest
  LABEL Name="Dinesh"
  LABEL ENV="Dev"
  WORKDIR /app
  RUN apt-get update && apt install apache2 -y
  COPY ./index.html /usr/local/apache2/htdocs
  ENTRYPOINT ["service", "apache2", "start"]
```
