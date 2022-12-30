
<br>

<div align = center>


[![Badge License]][License]   
[![Badge Conan]][Conan]

[![Badge Contributors]][Contributors]   
[![Badge Size]][#]

<br>
<br>

# PyNest2D

*CPython bindings for **[LibNest2D]**, a library <br>
to pack 2D polygons into a small space.*


<br>
<br>

[![Button Requirements]][Requirements]   
[![Button Usage]][Usage]

[![Button Building]][Building]   
[![Button Packaging]][Packaging]   
[![Button Developing]][Developing]

</div>

<br>
<br>

## Details

We may use as of yet unmerged work done on <br>
our own **[Fork]** of libnest2d whenever convenient.

Libnest2d implements the 2D bin packing problem.

The objective of this repository is to allow libnest2d <br>
functions to be called from Python using Numpy. 

To this end, there is a competing <br>
**[Solution][Nest2D]** to provide Python bindings.

However it doesn't expose enough of the configurability <br>
that Cura requires and its bindings aren't as transparent.

<br>


<!----------------------------------------------------------------------------->

[Contributors]: https://github.com/Ultimaker/pynest2d/graphs/contributors
[LibNest2D]: https://github.com/tamasmeszaros/libnest2d
[Nest2D]: https://github.com/markfink/nest2D
[Conan]: https://github.com/Ultimaker/pynest2d/actions/workflows/conan-package.yml
[Fork]: https://github.com/Ultimaker/libnest2d

[Requirements]: Documentation/System%20Requirements.md
[Developing]: Documentation/Developing.md
[Packaging]: Documentation/Packaging.md
[Building]: Documentation/Building.md
[Usage]: Documentation/Usage.md
[License]: LICENSE
[#]: #


<!---------------------------------[ Badges ]---------------------------------->

[Badge Contributors]: https://img.shields.io/github/contributors/ultimaker/pynest2d?style=for-the-badge&logoColor=white&labelColor=db5e8a&color=ab4a6c&logo=GitHub
[Badge License]: https://img.shields.io/badge/License-LGPL3-336887.svg?style=for-the-badge&labelColor=458cb5&logoColor=white&logo=GNU
[Badge Conan]: https://img.shields.io/github/workflow/status/Ultimaker/pynest2d/conan-package?style=for-the-badge&logoColor=white&labelColor=6185aa&color=4c6987&logo=Conan&label=Conan%20Package
[Badge Size]: https://img.shields.io/github/repo-size/ultimaker/pynest2d?style=for-the-badge&logoColor=white&labelColor=629944&color=446a30&logo=GoogleAnalytics


<!---------------------------------[ Buttons ]--------------------------------->

[Button Requirements]: https://img.shields.io/badge/System_Requirements-c34360?style=for-the-badge&logoColor=white&logo=BookStack
[Button Developing]: https://img.shields.io/badge/Developing-715a97?style=for-the-badge&logoColor=white&logo=VisualStudioCode
[Button Packaging]: https://img.shields.io/badge/Packaging-db5e8a?style=for-the-badge&logoColor=white&logo=GitLFS
[Button Building]: https://img.shields.io/badge/Building-458cb5?style=for-the-badge&logoColor=white&logo=CurseForge
[Button Usage]: https://img.shields.io/badge/Usage-629944?style=for-the-badge&logoColor=white&logo=GitBook

