Begin by installing [Docker](https://www.docker.com) or install the prereqs by running `sudo apt-get install bash curl git openssl jq`.

Now you are ready to kick off a new deployment:
```
# git clone https://github.com/okwolf/digital-ocean-docker.git && cd digital-ocean-docker && ./run.sh
Cloning into 'digital-ocean-docker'...
remote: Counting objects: 64, done.
remote: Compressing objects: 100% (4/4), done.
remote: Total 64 (delta 0), reused 0 (delta 0), pack-reused 60
Unpacking objects: 100% (64/64), done.
Checking connectivity... done.
Sending build context to Docker daemon 6.656 kB
Step 1 : FROM alpine
latest: Pulling from library/alpine

420890c9e918: Pull complete 
Digest: sha256:9cacb71397b640eca97488cf08582ae4e4068513101088e9f96c9814bfda95e0
Status: Downloaded newer image for alpine:latest
 ---> d7a513a663c1
Step 2 : RUN apk add --no-cache bash curl ncurses openssh openssl jq
 ---> Running in b76fba275103
fetch http://dl-cdn.alpinelinux.org/alpine/v3.3/main/x86_64/APKINDEX.tar.gz
fetch http://dl-cdn.alpinelinux.org/alpine/v3.3/community/x86_64/APKINDEX.tar.gz
(1/14) Installing ncurses-terminfo-base (6.0-r6)
(2/14) Installing ncurses-terminfo (6.0-r6)
(3/14) Installing ncurses-libs (6.0-r6)
(4/14) Installing readline (6.3.008-r4)
(5/14) Installing bash (4.3.42-r3)
Executing bash-4.3.42-r3.post-install
(6/14) Installing openssl (1.0.2g-r0)
(7/14) Installing ca-certificates (20160104-r2)
(8/14) Installing libssh2 (1.6.0-r1)
(9/14) Installing curl (7.47.0-r0)
(10/14) Installing jq (1.5-r0)
(11/14) Installing ncurses (6.0-r6)
(12/14) Installing openssh-client (7.2_p2-r0)
(13/14) Installing openssh-sftp-server (7.2_p2-r0)
(14/14) Installing openssh (7.2_p2-r0)
Executing busybox-1.24.1-r7.trigger
Executing ca-certificates-20160104-r2.trigger
OK: 19 MiB in 25 packages
 ---> 9457fc765f4c
Removing intermediate container b76fba275103
Step 3 : COPY . .
 ---> 32faac8e5653
Removing intermediate container abe4f092330b
Step 4 : CMD bash deploy.sh
 ---> Running in 45f403181184
 ---> 782fdb8dd9d9
Removing intermediate container 45f403181184
Successfully built 782fdb8dd9d9
```

You'll be prompted for required values not already set in your environment:
```
Enter your Digital Ocean token: a5004efd02b5184571c57f974f6bea96d9358546453e50fd9ef54bac10a726e8
Enter the git repo you wish to build: https://github.com/docker-training/webapp.git
Enter any options to use when running: -p 80:5000
Enter Droplet name prefix []: training-webapp
Enter Droplet region [sfo1]: 
Enter Droplet size [512mb]: 
Enter CoreOS channel [stable]: 
```

For reference here is a table of all available variables:

| Variable              | Required| Default|Usage|
| ----------------------|:-------:|:------:|-----|
| DO_TOKEN              | YES     |        | Authenticates all Digital Ocean API communications, see https://cloud.digitalocean.com/settings/api/tokens to create one |
| DO_DOCKER_BUILD_REPO  | YES     |        | Github repo to build with Docker |
| DO_DOCKER_RUN_OPTIONS | YES     |        | Flags to give Docker when running, i.e. -p for binding ports |
| DO_NAME_PREFIX        | NO      |        | Optional prefix to give Droplet for easier identification later. Names always include a unique suffix. 
| DO_REGION             | NO      | sfo1   | Datacenter region for creating Droplet (nyc1, nyc2, nyc3, ams2, ams3, sfo1, sgp1, lon1, fra1, tor1) |
| DO_SIZE               | NO      | 512mb  | Size of RAM to allocate for new machine, affects billing (512mb, 1gb, 2gb, 4gb, 8gb, 16gb, 32gb, 48gb, 64gb) |
| DO_CHANNEL            | NO      | stable | Release channel to use for CoreOS, affects updates (alpha, beta, stable) |

From here SSH keys will be generated if not already existing and uploaded to Digital Ocean for use by the new Droplet so that we can connect after creation and show the logs of the Docker build and run progress:
```
Generating public/private rsa key pair.
Your identification has been saved in /root/.ssh/id_rsa.
Your public key has been saved in /root/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:PJOrwhvuzkEuACcCPLau9gBMGSTfT/GchO4UMActnIQ root@023dd352e004
The key's randomart image is:
+---[RSA 2048]----+
|=o +==o..        |
|o=E.+o+= .       |
|=o= .o..+        |
|=+   oo. .       |
|+.  .o. S        |
|.o o  .  +       |
|....+   .        |
|...+oo .         |
|. .+*o.          |
+----[SHA256]-----+
Droplet training-webapp-9c765e893ee0 with ID 13946914 created!
Waiting for Droplet training-webapp-9c765e893ee0 to boot...
Droplet training-webapp-9c765e893ee0 booted.
Connecting to core@159.203.211.64...
-- Logs begin at Sat 2016-04-23 03:02:58 UTC. --
Apr 23 03:03:11 training-webapp-9c765e893ee0 bash[1011]: [95B blob data]
Apr 23 03:03:11 training-webapp-9c765e893ee0 bash[1011]: Step 1 : FROM ubuntu:14.04
Apr 23 03:03:12 training-webapp-9c765e893ee0 bash[1011]: 14.04: Pulling from library/ubuntu
Apr 23 03:03:12 training-webapp-9c765e893ee0 bash[1011]: 140d9fb3c81c: Pulling fs layer
Apr 23 03:03:12 training-webapp-9c765e893ee0 bash[1011]: 74a2c71e6050: Pulling fs layer
Apr 23 03:03:12 training-webapp-9c765e893ee0 bash[1011]: 44802199e669: Pulling fs layer
Apr 23 03:03:12 training-webapp-9c765e893ee0 bash[1011]: c88b54fedc4f: Pulling fs layer
Apr 23 03:03:13 training-webapp-9c765e893ee0 bash[1011]: 44802199e669: Verifying Checksum
Apr 23 03:03:13 training-webapp-9c765e893ee0 bash[1011]: 44802199e669: Download complete
Apr 23 03:03:13 training-webapp-9c765e893ee0 bash[1011]: c88b54fedc4f: Verifying Checksum
Apr 23 03:03:13 training-webapp-9c765e893ee0 bash[1011]: c88b54fedc4f: Download complete
Apr 23 03:03:14 training-webapp-9c765e893ee0 bash[1011]: 74a2c71e6050: Verifying Checksum
Apr 23 03:03:14 training-webapp-9c765e893ee0 bash[1011]: 74a2c71e6050: Download complete
Apr 23 03:03:19 training-webapp-9c765e893ee0 bash[1011]: 140d9fb3c81c: Verifying Checksum
Apr 23 03:03:19 training-webapp-9c765e893ee0 bash[1011]: 140d9fb3c81c: Download complete
Apr 23 03:03:29 training-webapp-9c765e893ee0 bash[1011]: 140d9fb3c81c: Pull complete
Apr 23 03:03:30 training-webapp-9c765e893ee0 bash[1011]: 74a2c71e6050: Pull complete
Apr 23 03:03:30 training-webapp-9c765e893ee0 bash[1011]: 44802199e669: Pull complete
Apr 23 03:03:31 training-webapp-9c765e893ee0 bash[1011]: c88b54fedc4f: Pull complete
Apr 23 03:03:31 training-webapp-9c765e893ee0 bash[1011]: Digest: sha256:28fd745dfe0a5f6e716437969c4927c2b4e44c13ce4230205e990608048edb6d
Apr 23 03:03:31 training-webapp-9c765e893ee0 bash[1011]: Status: Downloaded newer image for ubuntu:14.04
Apr 23 03:03:31 training-webapp-9c765e893ee0 bash[1011]: ---> c88b54fedc4f
Apr 23 03:03:31 training-webapp-9c765e893ee0 bash[1011]: Step 2 : MAINTAINER Docker Education Team <education@docker.com>
Apr 23 03:03:31 training-webapp-9c765e893ee0 bash[1011]: ---> Running in 31be325c7b65
Apr 23 03:03:32 training-webapp-9c765e893ee0 bash[1011]: ---> 82e7e12f363d
Apr 23 03:03:32 training-webapp-9c765e893ee0 bash[1011]: Removing intermediate container 31be325c7b65
Apr 23 03:03:32 training-webapp-9c765e893ee0 bash[1011]: Step 3 : RUN apt-get update
Apr 23 03:03:32 training-webapp-9c765e893ee0 bash[1011]: ---> Running in 48f92f7a0dd5
...
Apr 23 03:03:42 training-webapp-9c765e893ee0 bash[1011]: Fetched 21.7 MB in 7s (2790 kB/s)
Apr 23 03:03:44 training-webapp-9c765e893ee0 bash[1011]: Reading package lists...
Apr 23 03:03:46 training-webapp-9c765e893ee0 bash[1011]: ---> ca11d247c93e
Apr 23 03:03:46 training-webapp-9c765e893ee0 bash[1011]: Removing intermediate container 48f92f7a0dd5
Apr 23 03:03:46 training-webapp-9c765e893ee0 bash[1011]: Step 4 : RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q python-all python-pip
Apr 23 03:03:46 training-webapp-9c765e893ee0 bash[1011]: ---> Running in 1cd0087745c4
Apr 23 03:03:49 training-webapp-9c765e893ee0 bash[1011]: Reading package lists...
Apr 23 03:03:49 training-webapp-9c765e893ee0 bash[1011]: Building dependency tree...
Apr 23 03:03:49 training-webapp-9c765e893ee0 bash[1011]: Reading state information...
Apr 23 03:03:50 training-webapp-9c765e893ee0 bash[1011]: The following extra packages will be installed:
Apr 23 03:03:50 training-webapp-9c765e893ee0 bash[1011]: binutils build-essential ca-certificates cpp cpp-4.8 dpkg-dev fakeroot g++
Apr 23 03:03:50 training-webapp-9c765e893ee0 bash[1011]: g++-4.8 gcc gcc-4.8 libalgorithm-diff-perl libalgorithm-diff-xs-perl
Apr 23 03:03:50 training-webapp-9c765e893ee0 bash[1011]: libalgorithm-merge-perl libasan0 libatomic1 libc-dev-bin libc6-dev
Apr 23 03:03:50 training-webapp-9c765e893ee0 bash[1011]: libcloog-isl4 libdpkg-perl libfakeroot libfile-fcntllock-perl libgcc-4.8-dev
Apr 23 03:03:50 training-webapp-9c765e893ee0 bash[1011]: libgmp10 libgomp1 libisl10 libitm1 libmpc3 libmpfr4 libpython-stdlib
Apr 23 03:03:50 training-webapp-9c765e893ee0 bash[1011]: libpython2.7-minimal libpython2.7-stdlib libquadmath0 libstdc++-4.8-dev
Apr 23 03:03:50 training-webapp-9c765e893ee0 bash[1011]: libtimedate-perl libtsan0 linux-libc-dev make manpages manpages-dev openssl
Apr 23 03:03:50 training-webapp-9c765e893ee0 bash[1011]: patch python python-chardet python-chardet-whl python-colorama
Apr 23 03:03:50 training-webapp-9c765e893ee0 bash[1011]: python-colorama-whl python-distlib python-distlib-whl python-html5lib
Apr 23 03:03:50 training-webapp-9c765e893ee0 bash[1011]: python-html5lib-whl python-minimal python-pip-whl python-pkg-resources
Apr 23 03:03:50 training-webapp-9c765e893ee0 bash[1011]: python-requests python-requests-whl python-setuptools python-setuptools-whl
Apr 23 03:03:50 training-webapp-9c765e893ee0 bash[1011]: python-six python-six-whl python-urllib3 python-urllib3-whl python-wheel
Apr 23 03:03:50 training-webapp-9c765e893ee0 bash[1011]: python2.7 python2.7-minimal python3-pkg-resources xz-utils
Apr 23 03:03:50 training-webapp-9c765e893ee0 bash[1011]: Suggested packages:
Apr 23 03:03:50 training-webapp-9c765e893ee0 bash[1011]: binutils-doc cpp-doc gcc-4.8-locales debian-keyring g++-multilib
Apr 23 03:03:50 training-webapp-9c765e893ee0 bash[1011]: g++-4.8-multilib gcc-4.8-doc libstdc++6-4.8-dbg gcc-multilib autoconf
Apr 23 03:03:50 training-webapp-9c765e893ee0 bash[1011]: automake1.9 libtool flex bison gdb gcc-doc gcc-4.8-multilib libgcc1-dbg
Apr 23 03:03:50 training-webapp-9c765e893ee0 bash[1011]: libgomp1-dbg libitm1-dbg libatomic1-dbg libasan0-dbg libtsan0-dbg
Apr 23 03:03:50 training-webapp-9c765e893ee0 bash[1011]: libquadmath0-dbg glibc-doc libstdc++-4.8-doc make-doc man-browser ed
Apr 23 03:03:50 training-webapp-9c765e893ee0 bash[1011]: diffutils-doc python-doc python-tk python-genshi python-lxml
Apr 23 03:03:50 training-webapp-9c765e893ee0 bash[1011]: python-distribute python-distribute-doc python2.7-doc binfmt-support
Apr 23 03:03:50 training-webapp-9c765e893ee0 bash[1011]: python3-setuptools
Apr 23 03:03:50 training-webapp-9c765e893ee0 bash[1011]: Recommended packages:
Apr 23 03:03:50 training-webapp-9c765e893ee0 bash[1011]: python-dev-all
Apr 23 03:03:50 training-webapp-9c765e893ee0 bash[1011]: The following NEW packages will be installed:
Apr 23 03:03:50 training-webapp-9c765e893ee0 bash[1011]: binutils build-essential ca-certificates cpp cpp-4.8 dpkg-dev fakeroot g++
Apr 23 03:03:50 training-webapp-9c765e893ee0 bash[1011]: g++-4.8 gcc gcc-4.8 libalgorithm-diff-perl libalgorithm-diff-xs-perl
Apr 23 03:03:50 training-webapp-9c765e893ee0 bash[1011]: libalgorithm-merge-perl libasan0 libatomic1 libc-dev-bin libc6-dev
Apr 23 03:03:50 training-webapp-9c765e893ee0 bash[1011]: libcloog-isl4 libdpkg-perl libfakeroot libfile-fcntllock-perl libgcc-4.8-dev
Apr 23 03:03:50 training-webapp-9c765e893ee0 bash[1011]: libgmp10 libgomp1 libisl10 libitm1 libmpc3 libmpfr4 libpython-stdlib
Apr 23 03:03:50 training-webapp-9c765e893ee0 bash[1011]: libpython2.7-minimal libpython2.7-stdlib libquadmath0 libstdc++-4.8-dev
Apr 23 03:03:50 training-webapp-9c765e893ee0 bash[1011]: libtimedate-perl libtsan0 linux-libc-dev make manpages manpages-dev openssl
Apr 23 03:03:50 training-webapp-9c765e893ee0 bash[1011]: patch python python-all python-chardet python-chardet-whl python-colorama
Apr 23 03:03:50 training-webapp-9c765e893ee0 bash[1011]: python-colorama-whl python-distlib python-distlib-whl python-html5lib
Apr 23 03:03:50 training-webapp-9c765e893ee0 bash[1011]: python-html5lib-whl python-minimal python-pip python-pip-whl
Apr 23 03:03:50 training-webapp-9c765e893ee0 bash[1011]: python-pkg-resources python-requests python-requests-whl python-setuptools
Apr 23 03:03:50 training-webapp-9c765e893ee0 bash[1011]: python-setuptools-whl python-six python-six-whl python-urllib3
Apr 23 03:03:50 training-webapp-9c765e893ee0 bash[1011]: python-urllib3-whl python-wheel python2.7 python2.7-minimal
Apr 23 03:03:50 training-webapp-9c765e893ee0 bash[1011]: python3-pkg-resources xz-utils
Apr 23 03:03:51 training-webapp-9c765e893ee0 bash[1011]: 0 upgraded, 69 newly installed, 0 to remove and 5 not upgraded.
Apr 23 03:03:51 training-webapp-9c765e893ee0 bash[1011]: Need to get 46.9 MB of archives.
Apr 23 03:03:51 training-webapp-9c765e893ee0 bash[1011]: After this operation, 140 MB of additional disk space will be used.
...
Apr 23 03:04:58 training-webapp-9c765e893ee0 bash[1011]: Processing triggers for libc-bin (2.19-0ubuntu6.7) ...
Apr 23 03:04:58 training-webapp-9c765e893ee0 bash[1011]: Processing triggers for ca-certificates (20160104ubuntu0.14.04.1) ...
Apr 23 03:05:00 training-webapp-9c765e893ee0 bash[1011]: Updating certificates in /etc/ssl/certs... 173 added, 0 removed; done.
Apr 23 03:05:00 training-webapp-9c765e893ee0 bash[1011]: Running hooks in /etc/ca-certificates/update.d....done.
Apr 23 03:05:07 training-webapp-9c765e893ee0 bash[1011]: ---> 4ab80fce0216
Apr 23 03:05:07 training-webapp-9c765e893ee0 bash[1011]: Removing intermediate container 1cd0087745c4
Apr 23 03:05:07 training-webapp-9c765e893ee0 bash[1011]: Step 5 : ADD ./webapp/requirements.txt /tmp/requirements.txt
Apr 23 03:05:10 training-webapp-9c765e893ee0 bash[1011]: ---> 287172c93ce0
Apr 23 03:05:10 training-webapp-9c765e893ee0 bash[1011]: Removing intermediate container 0a2d41d09e42
Apr 23 03:05:10 training-webapp-9c765e893ee0 bash[1011]: Step 6 : RUN pip install -qr /tmp/requirements.txt
Apr 23 03:05:10 training-webapp-9c765e893ee0 bash[1011]: ---> Running in 60d9e9df7a73
Apr 23 03:05:17 training-webapp-9c765e893ee0 bash[1011]: ---> 6dd4c0aca6b8
Apr 23 03:05:17 training-webapp-9c765e893ee0 bash[1011]: Removing intermediate container 60d9e9df7a73
Apr 23 03:05:17 training-webapp-9c765e893ee0 bash[1011]: Step 7 : ADD ./webapp /opt/webapp/
Apr 23 03:05:19 training-webapp-9c765e893ee0 bash[1011]: ---> 2ff46771e8e5
Apr 23 03:05:19 training-webapp-9c765e893ee0 bash[1011]: Removing intermediate container d389ecc0cc45
Apr 23 03:05:19 training-webapp-9c765e893ee0 bash[1011]: Step 8 : WORKDIR /opt/webapp
Apr 23 03:05:19 training-webapp-9c765e893ee0 bash[1011]: ---> Running in a15f6c984a29
Apr 23 03:05:21 training-webapp-9c765e893ee0 bash[1011]: ---> c79b969ead00
Apr 23 03:05:21 training-webapp-9c765e893ee0 bash[1011]: Removing intermediate container a15f6c984a29
Apr 23 03:05:21 training-webapp-9c765e893ee0 bash[1011]: Step 9 : EXPOSE 5000
Apr 23 03:05:21 training-webapp-9c765e893ee0 bash[1011]: ---> Running in aab03395e07d
Apr 23 03:05:23 training-webapp-9c765e893ee0 bash[1011]: ---> 909b4d3e09fc
Apr 23 03:05:23 training-webapp-9c765e893ee0 bash[1011]: Removing intermediate container aab03395e07d
Apr 23 03:05:23 training-webapp-9c765e893ee0 bash[1011]: Step 10 : CMD python app.py
Apr 23 03:05:23 training-webapp-9c765e893ee0 bash[1011]: ---> Running in c196ca88b04c
Apr 23 03:05:26 training-webapp-9c765e893ee0 bash[1011]: ---> 2001035bdd07
Apr 23 03:05:26 training-webapp-9c765e893ee0 bash[1011]: Removing intermediate container c196ca88b04c
Apr 23 03:05:26 training-webapp-9c765e893ee0 bash[1011]: Successfully built 2001035bdd07
Apr 23 03:05:26 training-webapp-9c765e893ee0 bash[1011]: * Running on http://0.0.0.0:5000/ (Press CTRL+C to quit)
Apr 23 03:05:52 training-webapp-9c765e893ee0 bash[1011]: 174.68.88.217 - - [23/Apr/2016 03:05:52] "GET / HTTP/1.1" 200 -
```
