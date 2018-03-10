# uplat
Simple, heuristic shell script that prints the platform (distro) name

This simple shell script prints the platform name.

The platform name is composed of the following 4 parts:

```
<plat>-<dist>-<ver>-<arch>
^      ^      ^     ^
|      |      |     +----- architecture: x86_64, i86pc, etc.
|      |      +----------- version: 5.5, 6.4, 10.9, etc.
|      +------------------ distribution: centos, debian, macosx, ubuntu
+------------------------- platform: linux, sunos, darwin
```

Since there is no accepted standard for finding the platform name on different distros, the script uses heuristics which means that it will not work for all platforms. If you have a solution for an unsupported platform, please let me know so that this tool can be updated.

Here are some platforms it has been used on successfully.

1. darwin-macos-10.13.3-x86_64
2. linux-centos-5.11-x86_64
3. linux-centos-6.9-x86_64
4. linux-centos-7.4.1708-x86_64
5. linux-debian-9-x86_64
6. linux-fedora-27-x86_64
7. linux-ubuntu-16.04.3-x86_64

Running it is trivial.

```bash
$ uplat.sh
darwin-macos-10.13.3-x86_64
```
