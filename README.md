phd-tools
==========

**Maintainer:** Francisco Suárez Ruiz, [http://www.romin.upm.es/fsuarez/](http://www.romin.upm.es/fsuarez/)

### Documentation
* See the installation instructions below.
* Throughout the various files in the repository.

## Installation

Go to your working directory. e.g.
```
$ cd ~/git
``` 
Clone the following repositories:
```
$ git clone https://github.com/fsuarez6/phd-tools.git
$ git clone https://github.com/nschloe/matlab2tikz.git
$ git clone https://github.com/bcharrow/matlab_rosbag.git -b hydro-devel
``` 

Additionally you will need:
* The Robotics Toolbox for Matlab. Download it from [http://www.petercorke.com/RTB/](http://www.petercorke.com/RTB/). Current used version: **9.9** 
* Matlab reader and writer of YAML formated files. Download it from [here](https://code.google.com/p/yamlmatlab/downloads/list). Current used version: **0.4.3** 

Unzip both of them inside the `phd-tools` folder.

### Octave

Many of the scripts work with octave 3.8.1 or newer and octave-java 1.2.9 or newer.

If your Ubuntu version is too old (e.g. 12.04), you'll have to install things manually.
First, install latest stable octave:
```
$ sudo apt-add-repository ppa:octave/stable
$ sudo apt-get update
$ sudo apt-get install octave liboctave-dev
``` 

Now install the java package:
```
$ octave
octave:1> setenv("JAVA_HOME", "/usr/lib/jvm/java-7-oracle");
octave:2> pkg install -forge java
``` 

In another console create this symlink:
```
sudo ln -s -v '/usr/lib/jvm/default-java/jre/lib/amd64/server' '/usr/lib/jvm/default-java/jre/lib/amd64/client'
``` 

## Changelog
### 0.1.0 (2014-07-29)
* Initial Release
