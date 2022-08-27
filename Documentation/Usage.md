
# Usage

*An example on how to arrange multiple shapes in a volume.*

<br>

> **Note** <br>
> These bindings stay close to the original function signatures. <br>
> For full documentation, see **[LibNest2D]**.



<br>

```Python
from pynest2d import *


# 1000 x 1000 bounding volume centered around 
# 0 in which the items must be arranged.

volume = Box(1000,1000)


long_thin_triangle = Item([
    Point(  0  ,  0  ),
    Point( 100 , 100 ),
    Point(  50 , 100 )
])

square = Item([
    Point(  0  ,  0  ),
    Point( 100 ,  0  ),
    Point( 100 , 100 ),
    Point(  0  , 100 )
])

equilateral_triangle = Item([
    Point(  0  ,  0  ),
    Point( 100 ,  0  ),
    Point(  50 , 100 )
])


# The actual arranging!

num_bins = nest([ long_thin_triangle , square , equilateral_triangle ],volume)
```

```Python
# How many bins are required to add all objects.
num_bins  #  1
```

```Python
# Doesn't modify the original item
transformed_i1 = long_thin_triangle.transformedShape()
```

```Python
print(transformed_i1.toString())

# Contour {
#    18 96
#    117 46
#    117 -4
#    18 96
# }
```

```Python
transformed_i.vertex(0).x()  #  18
transformed_i.vertex(0).y()  #  96
long_thin_triangle.rotation()  #  4.71238898038469
```

<br>


<!----------------------------------------------------------------------------->

[LibNest2D]: https://github.com/tamasmeszaros/libnest2d