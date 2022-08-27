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