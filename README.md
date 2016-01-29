# docker-LAMP-aur
This is the exact same as https://github.com/greyltc/docker-LAMP (except it's setup for installing from the AUR). See the readme there.

Containers based on this one can use the following to install `PACKAGE` from the AUR:
```bash
su docker -c 'pacaur -Syyu --noedit --noconfirm PACKAGE'
```

So in your Dockerfile, that would look like:
```dockerfile
RUN su docker -c 'pacaur -Syyu --noedit --noconfirm PACKAGE'
```
