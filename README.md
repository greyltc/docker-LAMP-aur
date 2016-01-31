# docker-LAMP-aur
This is exactly the same as https://github.com/greyltc/docker-LAMP with the following exception:

Containers based on this one can use the following to install `PACKAGE` from the AUR:
```bash
su docker -c 'pacaur -S --noprogressbar --noedit --noconfirm PACKAGE'
```

So in your Dockerfile, that would look like:
```dockerfile
RUN su docker -c 'pacaur -S --noprogressbar --noedit --noconfirm PACKAGE'
```
