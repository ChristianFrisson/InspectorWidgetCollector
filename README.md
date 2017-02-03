# InspectorWidget Collector

## Introduction

InspectorWidget is an opensource suite to track and analyze users behaviors in their applications. 

The key contributions of InspectorWidget are:
1) it works on closed applications that do not provide source code nor scripting capabilities; 
2) it covers the whole pipeline of software analysis from logging input events and accessibility data to visual statistics through browsing and programmable annotation; 
3) it allows post-recording logging; and 4) it does not require programming skills. To achieve this, InspectorWidget combines low-level event logging (e.g. mouse and keyboard events) and high-level screen features (e.g. interface widgets) captured though computer vision techniques. 

InspectorWidget is targeted at end users, usability experts, user experience and HCI researchers.

## Distribution

[InspectorWidget](https://github.com/InspectorWidget/InspectorWidget) is composed of three tools:
- [Collector](https://github.com/InspectorWidget/InspectorWidgetCollector): Record (screen), Log (input events + accessibility data) 
- [Iterator](https://github.com/InspectorWidget/InspectorWidgetIterator): Browse (screen + input events + accessibility data), Program (annotations), Analyze (workflows)
- [Processor](https://github.com/InspectorWidget/InspectorWidgetProcessor): Automate (annotations)

### InspectorWidget Collector

The Collector tool is a cross-platform desktop application for recording screen and input events. 

It is based on:
- [jp9000](https://github.com/jp9000) / [obs-studio](https://github.com/jp9000/obs-studio): an application for screen recording and live streaming
- [kwhat](https://github.com/kwhat) / [libuiohook](https://github.com/kwhat/libuiohook): a library for hooking input events

## Installation

First clone the repository.
Then open a terminal in the source directory (`<source_path>`):
* update all submodules: 
```git submodule update --init```

Note: the [input-accessibility](https://github.com/InspectorWidget/InspectorWidgetCollector/tree/InspectorWidget/plugins/input-accessibility) plugin is currently available only for Apple OSX. Otherwise everything is cross-platform for the following desktop operating systems:

### Apple OSX 10.9+

#### Dependencies

Install cmake, qt5 and ffmpeg with your package manager:
 * [Homebrew](http://brew.sh):
```brew install cmake ffmpeg qt5```
 * [MacPorts](https://www.macports.org):
```sudo port install cmake ffmpeg qt5```

#### Compilation

Create a build folder, open a terminal inside:
* set that we are creating a bundle: 
```
export FIXUP_BUNDLE=1
```
* configure cmake: 
```
cmake <source_path>
```
Note: replace `<source_path>` with the path to the source directory from above, optionally add `-DCMAKE_PREFIX_PATH=<qt5_path>` if Qt5 is installed in a specific location.
* compile and create the package: 
```
make package
```

### Windows 9+: cross-compile on Apple OSX or Linux using mxe

Install [mxe](http://mxe.cc) (M cross environment):
* follow its [tutorial](http://mxe.cc/#tutorial)
* you will need to install the following packages:
```make qtbase pthreads x264 curl ffmpeg widl --jobs=`<jobs>` JOBS=`<jobs>` --keep-going```
with `<jobs>` replaced by `nproc` on Linux or `sysctl -n hw.logicalcpu` on OSX

Create a build folder, open a terminal inside:
* configure cmake: 
```cmake <source_path> -DCMAKE_TOOLCHAIN_FILE=<mxe_path>/usr/i686-w64-mingw32.static/share/cmake/mxe-conf.cmake -DCMAKE_VERBOSE_MAKEFILE=ON -DCMAKE_INSTALL_PREFIX=release```
replace `<source_path>` with the path to the source directory from above
replace `<mxe_path>` with the root path where mxe is installed
* compile:```make```
* make a portable distribution: 
```touch release/portable_mode.txt```
* launch (from a virtual or physical machine running Windows): `bin/32bits/obs32.exe`

### Linux

Not yet tested.

## Contributing

Feel free to fork, try, mod, and issue pull requests!

The InspectorWidget Collector active/inactive icons have been sketched using [Pencil](https://github.com/evolus/pencil) with its [fontawesome](http://fontawesome.io) icons stencil. The [project file](https://github.com/InspectorWidget/InspectorWidgetCollector/tree/InspectorWidget/UI/forms/images/InspectorWidgetCollector.ep) is part of the distribution. A redesign is welcome!

## License

InspectorWidget Collector is released under the terms of the [GPLv2](http://www.gnu.org/licenses/gpl-2.0.html) license.

## Authors
 * [jp9000](https://github.com/jp9000/) and many other [contributors](https://github.com/jp9000/obs-studio/graphs/contributors): creators and developers of [obs-studio](https://github.com/jp9000/obs-studio) which InspectorWidget Collector forks
 * [kwhat](https://github.com/kwhat/): creator and developer of the [libuiohook](https://github.com/kwhat/libuiohook) library
 * [Sylvain Malacria](http://malacria.com) (Inria Lille): creator of [AXRecord](https://github.com/InspectorWidget/AXRecord) 
 * [Christian Frisson](http://christian.frisson.re) (initially University of Mons, now Inria Lille): creator of the [input-accessibility](https://github.com/InspectorWidget/InspectorWidgetCollector/tree/InspectorWidget/plugins/input-accessibility) and [input-uiohook](https://github.com/InspectorWidget/InspectorWidgetCollector/tree/InspectorWidget/plugins/input-uiohook) plugins and the InspectorWidget Collector fork