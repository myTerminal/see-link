# see-link

[![Built with Lisp](https://img.shields.io/badge/built%20with-Lisp-blueviolet)](https://lisp-lang.org)
[![License](https://img.shields.io/github/license/myTerminal/see-link.svg)](https://opensource.org/licenses/MIT)  
[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/Y8Y5E5GL7)

A tool to simplify working with external displays on Linux

## Installation

There are a few different ways to get *see-link*.

### Compile from source

    # Clone project to the local workspace
    git clone https://github.com/myTerminal/see-link.git

    # Switch to the project directory
    cd see-link

    # Install with `make`
    make install

### Through a package manager

*see-link* will soon be available to install from your operating system's package manager.

## How to Use

A simple way to use *see-link* is to run it in a command-line terminal passing specifying whether you need to connect or disconnect external displays.

    see-link connect

By default, any available external display(s) will be attached to the left of the primary device. You can also optionally specify whether you'd like to attach the displays to the left or to the right.

    see-link connect right

The above command would connect external displays to the right of the primary device.

> **Note:**: Device direction is currently only supported for Xorg.

In order to disconnect, simply run the below command.

    see-link disconnect

The behavior in absence of any arguments is as follows:

1. When external display devices are available, a `connect` operation is performed
2. When no external display device is connected, a `disconnect` operation is performed

### Further help with commands

To learn more about usage, refer to `manpage`:

    man see-link

## Updating

In order to update *see-link*, simply run:

    see-link-update

## Uninstalling

In order to uninstall *see-link*, simply run:

    see-link-uninstall

## External Dependencies

Being written with Common Lisp, *see-link* depends on [SBCL](https://www.sbcl.org). In most cases, it will be automatically installed while generating the binary, but if it doesn't please install it before running the installation.

The other required programs are as follows:

 - [xrandr](https://www.x.org/releases/X11R7.5/doc/man/man1/xrandr.1.html) for [Xorg](https://www.x.org) sessions.
 - [wlr-randr](https://sr.ht/~emersion/wlr-randr) for [Wayland](https://wayland.freedesktop.org)

## To-do

* Support for more orientations
* Live connect-disconnect
* Remember devices and their last used orientation
