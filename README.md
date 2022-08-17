# pynest2d

<p align="center">
    <a href="https://github.com/Ultimaker/pynest2d/actions/workflows/conan-package.yml" alt="Conan Package">
        <img src="https://github.com/Ultimaker/pynest2d/actions/workflows/conan-package.yml/badge.svg" /></a>
    <a href="https://github.com/Ultimaker/pynest2d/issues" alt="Open Issues">
        <img src="https://img.shields.io/github/issues/ultimaker/pynest2d" /></a>
    <a href="https://github.com/Ultimaker/pynest2d/issues?q=is%3Aissue+is%3Aclosed" alt="Closed Issues">
        <img src="https://img.shields.io/github/issues-closed/ultimaker/pynest2d?color=g" /></a>
    <a href="https://github.com/Ultimaker/pynest2d/pulls" alt="Pull Requests">
        <img src="https://img.shields.io/github/issues-pr/ultimaker/pynest2d" /></a>
    <a href="https://github.com/Ultimaker/pynest2d/graphs/contributors" alt="Contributors">
        <img src="https://img.shields.io/github/contributors/ultimaker/pynest2d" /></a>
    <a href="https://github.com/Ultimaker/pynest2d" alt="Repo Size">
        <img src="https://img.shields.io/github/repo-size/ultimaker/pynest2d?style=flat" /></a>
    <a href="https://github.com/Ultimaker/pynest2d/blob/master/LICENSE" alt="License">
        <img src="https://img.shields.io/github/license/ultimaker/pynest2d?style=flat" /></a>
</p>

This repository contains CPython bindings for [libnest2d](https://github.com/tamasmeszaros/libnest2d) (though note that we may use as of yet
unmerged work done on [our own fork of libnest2d, here](https://github.com/Ultimaker/libnest2d) whenever convenient), a library to pack 2D
polygons into a small space. Libnest2d implements the 2D bin packing problem.

The objective of this repository is to allow libnest2d to be called from Python using Numpy. There is
a [competing solution](https://github.com/markfink/nest2D) to provide Python bindings to this end. However it doesn't expose enough of the
configurability for Cura's purposes. This repository aims to be a more transparent binding of libnest2d.

## License

![License](https://img.shields.io/github/license/ultimaker/pynest2d?style=flat)  
pynest2d is released under terms of the LGPLv3 License. Terms of the license can be found in the LICENSE file. Or at
http://www.gnu.org/licenses/lgpl.html

> But in general it boils down to:  
> **You need to share the source of any pynest2d modifications if you make an application with pynest2d.**

## System Requirements

### Windows
- Python 3.6 or higher
- Ninja 1.10 or higher
- VS2022 or higher
- CMake 3.23 or higher
- nmake
- sip 6.5.0 or higher

### MacOs
- Python 3.6 or higher
- Ninja 1.10 or higher
- apply clang 11 or higher
- CMake 3.23 or higher
- make
- sip 6.5.0 or higher

### Linux
- Python 3.6 or higher
- Ninja 1.10 or higher
- gcc 12 or higher
- CMake 3.23 or higher
- make
- sip 6.5.0 or higher


## How To Build

> **Note:**  
> We are currently in the process of switch our builds and pipelines to an approach which uses [Conan](https://conan.io/)
> and pip to manage our dependencies, which are stored on our JFrog Artifactory server and in the pypi.org.
> At the moment not everything is fully ported yet, so bare with us.

If you want to develop Cura with pynest2d see the Cura Wiki: [Running Cura from source](https://github.com/Ultimaker/Cura/wiki/Running-Cura-from-Source)

If you have never used [Conan](https://conan.io/) read their [documentation](https://docs.conan.io/en/latest/index.html)
which is quite extensive and well maintained. Conan is a Python program and can be installed using pip

### 1. Configure Conan

```bash
pip install conan --upgrade
conan config install https://github.com/ultimaker/conan-config.git
conan profile new default --detect --force
```

Community developers would have to remove the Conan cura repository because it requires credentials. 

Ultimaker developers need to request an account for our JFrog Artifactory server at IT
```bash
conan remote remove cura
```

### 2. Clone pynest2d
```bash
git clone https://github.com/Ultimaker/pynest2d.git
cd pynest2d
```

### 3. Install & Build pynest2d (Release OR Debug)

#### Release
```bash
conan install . --build=missing --update
# optional for a specific version: conan install . pynest2d/<version>@<user>/<channel> --build=missing --update
conan build .
# or
sip-install
```

#### Debug

```bash
conan install . --build=missing --update build_type=Debug
conan build .
# or
sip-install
```

## Creating a new pynest2d Conan package

To create a new pynest2d Conan package such that it can be used in Cura and Uranium, run the following command:

```shell
conan create . pynest2d/<version>@<username>/<channel> --build=missing --update
```

This package will be stored in the local Conan cache (`~/.conan/data` or `C:\Users\username\.conan\data` ) and can be used in downstream
projects, such as Cura and Uranium by adding it as a requirement in the `conanfile.py` or in `conandata.yml`.

Note: Make sure that the used `<version>` is present in the conandata.yml in the pynest2d root

You can also specify the override at the commandline, to use the newly created package, when you execute the `conan install`
command in the root of the consuming project, with:


```shell
conan install . -build=missing --update --require-override=pynest2d/<version>@<username>/<channel>
```

## Developing pynest2d In Editable Mode

You can use your local development repository downsteam by adding it as an editable mode package.
This means you can test this in a consuming project without creating a new package for this project every time.

```bash
    conan editable add . pynest2d/<version>@<username>/<channel>
```

Then in your downsteam projects (Cura) root directory override the package with your editable mode package.  

```shell
conan install . -build=missing --update --require-override=pynest2d/<version>@<username>/<channel>
```

## Usage

This is an example of how you can use these Python bindings to arrange multiple shapes in a volume.

```python
>>> from pynest2d import *
>>> bin = Box(1000, 1000)  # A bounding volume in which the items must be arranged, a 1000x1000 square centered around 0.
>>> i1 = Item([Point(0, 0), Point(100, 100), Point(50, 100)])                # Long thin triangle.
>>> i2 = Item([Point(0, 0), Point(100, 0), Point(100, 100), Point(0, 100)])  # Square.
>>> i3 = Item([Point(0, 0), Point(100, 0), Point(50, 100)])                  # Equilateral triangle.
>>> num_bins = nest([i1, i2, i3], bin)  # The actual arranging!
>>> num_bins  # How many bins are required to add all objects.
1
>>> transformed_i1 = i1.transformedShape()  # The original item is unchanged, but the transformed shape is.
>>> print(transformed_i1.toString())
Contour {
    18 96
    117 46
    117 -4
    18 96
}
>>> transformed_i.vertex(0).x()
18
>>> transformed_i.vertex(0).y()
96
>>> i1.rotation()
4.71238898038469
```

For full documentation, see [libnest2d](https://github.com/tamasmeszaros/libnest2d). These bindings stay close to the original function
signatures.