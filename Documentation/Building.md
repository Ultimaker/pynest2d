
# Building

<br>

> We are currently in the process of switch our builds <br>
> and pipelines to an approach which uses **[Conan]** and <br>
> pip to manage our dependencies, which are stored <br>
> on our **JFrog Artifactory** server and in the pypi.org.
>
> *Not everything has been fully ported yet, so bare with us.*


<br>
<br>

## Related

If you want to develop Cura with PyNest2D see the **[Cura Wiki][Cura From Source]**.

**[Conan]** is a Python program and can be installed using pip. <br>
If you have never used it read their **[Documentation][Conan Docs]** which <br>is quite extensive and well maintained.


<br>
<br>

## Configuring Conan

<br>

```shell
pip install conan --upgrade
conan config install https://github.com/ultimaker/conan-config.git
conan profile new default --detect --force
```

<br>

Community developers would have to remove the <br>
Conan cura repository because it requires credentials. 

Ultimaker developers need to request an <br>
account for our JFrog Artifactory server at IT.

```shell
conan remote remove cura
```

<br>
<br>

## Clone PyNest2D

<br>

```shell
git clone https://github.com/Ultimaker/pynest2d.git
cd pynest2d
```

<br>
<br>

## Building & Installation

<br>

### Release

```shell
conan install . --build=missing --update
# optional for a specific version: conan install . pynest2d/<version>@<user>/<channel> --build=missing --update
conan build .
```
**or**

```shell
sip-install
```

<br>

### Debug

```shell
conan install . --build=missing --update build_type=Debug
conan build .
```

**or**

```shell
sip-install
```

<br>


<!----------------------------------------------------------------------------->

[Cura From Source]: https://github.com/Ultimaker/Cura/wiki/Running-Cura-from-Source
[Conan Docs]: https://docs.conan.io/en/latest/index.html
[Conan]: https://conan.io/
