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