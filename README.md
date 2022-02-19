Introduction and Scope
====
This repository contains CPython bindings for [libnest2d](https://github.com/tamasmeszaros/libnest2d) (though note that we may use as of yet unmerged work done on [our own fork of libnest2d, here](https://github.com/Ultimaker/libnest2d) whenever convenient), a library to pack 2D polygons into a small space. Libnest2d implements the 2D bin packing problem.

The objective of this repository is to allow libnest2d to be called from Python using Numpy. There is a [competing solution](https://github.com/markfink/nest2D) to provide Python bindings to this end. However it doesn't expose enough of the configurability for Cura's purposes. This repository aims to be a more transparent binding of libnest2d.

Usage
====
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

For full documentation, see [libnest2d](https://github.com/tamasmeszaros/libnest2d). These bindings stay close to the original function signatures.

Building
====
This library has a couple of dependencies that need to be installed prior to building:
* [libnest2d](https://github.com/Ultimaker/libnest2d), the library for which this library offers CPython bindings, and its dependencies:
  * [Clipper](http://www.angusj.com/delphi/clipper.php), a polygon clipping library.
  * [NLopt](https://nlopt.readthedocs.io/en/latest/), a library to solve non-linear optimization problems.
  * [Boost](https://www.boost.org/), the headers only.
* [Sip](https://www.riverbankcomputing.com/software/sip/download), an application to generate Python bindings more easily.
