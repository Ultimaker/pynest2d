
# Developing PyNest2D <br> In Editable Mode

<br>

You can use your local development repository downsteam <br>
by adding it as an editable mode package, which also means <br>
that you can test it in a consuming project without creating <br>
a new package for this project every time.


```shell
conan editable add . \
    pynest2d/<version>@<username>/<channel>
```

<br>

Then in your downsteam project's ( Cura ) root directory <br>
override the package with your editable mode package.  

```shell
conan install .     \
    -build=missing  \
    --update        \
    --require-override=pynest2d/<version>@<username>/<channel>
```

<br>