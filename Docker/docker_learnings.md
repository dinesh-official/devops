#### Master Adv Dockerfile and Docker Networking - Part 3
```
FROM ‹basimage >
WORKDIR /app
COPY ‹source > ‹destination>
RUN apt install git
ENTRYPOINT python3 main.py

```
#### Interview Questions
```
1. How do you decrease the Docker file size?
Ans: I reduce Docker image size by using lightweight base images like Alpine or Distroless (Blackbox), which are smaller and more efficient than Ubuntu or Debian.

 2. What is the difference between the COPY and ADD commands in a Dockerfile?
Ans: COPY only copies local files into the image.
 ADD can copy files and also extract tar files or download from URLs.
```
