Introduction and Scope
====
This repository contains CPython bindings for [libnest2d](https://github.com/tamasmeszaros/libnest2d), a library to pack 2D polygons into a small space. Libnest2d implements the 2D bin packing problem.

The objective of this repository is to allow libnest2d to be called from Python using Numpy. There is a [competing solution](https://github.com/markfink/nest2D) to provide Python bindings to this end. However this solution is licensed under AGPL. Since [Cura](https://github.com/Ultimaker/Cura) uses an LGPL license, it could not use that solution. This implementation also doesn't require a copy into Boost's data structure, but provides a back-end for Numpy instead.

Building
====
This library has a couple of dependencies that need to be installed prior to building:
* [libnest2d](https://github.com/tamasmeszaros/libnest2d), the library for which this library offers CPython bindings, and its dependencies:
  * [Clipper](http://www.angusj.com/delphi/clipper.php), a polygon clipping library.
  * [NLopt](https://nlopt.readthedocs.io/en/latest/), a library to solve non-linear optimization problems.
* [Sip](https://www.riverbankcomputing.com/software/sip/download), an application to create Python bindings more easily.
