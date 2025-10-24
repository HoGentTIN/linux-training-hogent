## Python package management best practices

Basically, there are three obvious ways to install a Python-based application or library:

- Using the system package manager (using the package manager of your Linux distribution, try looking for packages with names starting with `python-` or `python3-`).
- Using Python's own package manager, `pip` (either system-wide or under a user account).
- Using a Python virtual environment (which also uses `pip`, but in an isolated environment).

The advantage of using the system package manager is that it integrates well with the rest of your system. For running a Python-based application or CLI tool, this is the preferred way. However, on distributions with slower release cycles, these packages are probably not the latest released versions.

In that case, one might be tempted to use `pip` to install a more recent version of a package. However, this could lead to version conflicts with packages installed by the system package manager. For this reason, Linux distributions may discourage or even forbid the use of `pip` to install packages system-wide.

The following example is taken from Fedora 42:

```console
student@fedora-42:~$ sudo pip install pandas
[ ... some output omitted ... ]
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager, possibly rendering your system unusable.It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv. Use the --root-user-action option if you know what you are doing and want to suppress this warning.
```

On Debian 13, you can even see the following message:

```console
student@debian-13:~$ sudo pip install pandas
error: externally-managed-environment

× This environment is externally managed
╰─> To install Python packages system-wide, try apt install
    python3-xyz, where xyz is the package you are trying to
    install.
    
    If you wish to install a non-Debian-packaged Python package,
    create a virtual environment using python3 -m venv path/to/venv.
    Then use path/to/venv/bin/python and path/to/venv/bin/pip. Make
    sure you have python3-full installed.
    
    If you wish to install a non-Debian packaged Python application,
    it may be easiest to use pipx install xyz, which will manage a
    virtual environment for you. Make sure you have pipx installed.
    
    See /usr/share/doc/python3.13/README.venv for more information.

note: If you believe this is a mistake, please contact your Python installation or OS distribution provider. You can override this, at the risk of breaking your Python installation or OS, by passing --break-system-packages.
hint: See PEP 668 for the detailed specification.
```

Depending on your Linux distribution, `pip` may be allowed for user installations (i.e., without `sudo` and/or the `--user` option), but it seems that this as well is being discouraged or even forbidden on recent distributions. You could modify the system settings to allow this, but you would be going against the recommendations of your distribution.

That means that the remaining recommended way to do local Python package management is to use a Python virtual environment, i.e. a directory tree that contains all that is needed to run a specific Python project, up to and including a specific Python interpreter binary. The advantage is that this allows you to create a reproducible environment for your project that can be run on other machines as well, with a guaranteed set of package versions that will not conflict with other projects or with system packages. The disadvantage is that this environment is confined to the specific project and cannot be used system-wide.

## demo Python script

In order to demonstrate the use of a virtual environment, we will use the Python script below. It loads the publicly available [Palmer Penguins](https://allisonhorst.github.io/palmerpenguins/) dataset, does some data cleaning, builds a linear regression model (and prints the result), and creates a plot (which is saved to a file).

In order to work, the script requires the `seaborn` and `scikit-learn` packages to be installed.

Take a note of the shebang at the beginning of the script. We will explain later why we chose this specific form.

```python
#! /usr/bin/env python3
import seaborn as sns
from sklearn.linear_model import LinearRegression

# Load the Palmer Penguins demo dataset
penguins = sns.load_dataset('penguins')
# Select only needed colums and drop NaNs
df_flipper_mass = penguins[['flipper_length_mm', 'body_mass_g']].dropna()

# Build linear regression model
lm_flipper_mass = LinearRegression().fit(
    df_flipper_mass[['flipper_length_mm']].values,
    df_flipper_mass[['body_mass_g']].values)

# Print regression line coefficients
print(f"Regression line: mass = %.4f + %.4f x fl_length" %
      (lm_flipper_mass.intercept_[0], lm_flipper_mass.coef_[0,0]))

# Plot scatter plot for flipper length and body mass
plot_flipper_mass = sns.relplot(data=penguins,
    x='flipper_length_mm', y='body_mass_g', 
    hue='species', style='sex');

# Add regression line to the plot
sns.regplot(data=df_flipper_mass,
    x='flipper_length_mm', y='body_mass_g',
    scatter=False, ax=plot_flipper_mass.ax);

# Save to output/ directory (is expected to exist!)
plot_flipper_mass.figure.savefig('output/penguins_flipper_mass.png')
```

Create a directory, save the script above to a file called `penguins.py` inside that directory, and create an empty subdirectory called `output/` (where the plot will be saved).

```console
student@linux:~$ mkdir -p penguins/output
student@linux:~$ cd penguins/
student@linux:~/penguins$ nano penguins.py
[... paste the script above and save ...]
student@linux:~/penguins$ chmod +x penguins.py 
student@linux:~/penguins$ ls -l
total 8
drwxrwxr-x 2 student student 4096 Oct 22 12:28 output
-rwxrwxr-x 1 student student 1087 Oct 22 12:28 penguins.py
```

## setting up a virtual environment

To create a virtual environment, you can use the `venv` module that is part of the Python standard library. Ensure that the module is available on your system by installing the appropriate package using the system package manager. On Debian-based distribution, the name of the package is `python3-venv`. On EL and derivatives, the `venv` module is included in `python3-libs`.

Remark that the use of the `venv` module is not the only way to create virtual environments. Multiple solutions and third-party tools exist, such as `virtualenv`, `conda`, `pipx`, `uv`, etc. However, between those, there is no clear "winner", and each has its pros and cons.
 
Since `venv` is part of the standard library, that's the one we will use in this chapter.

You can create a new virtual environment by running the following command:

```console
student@linux:~/penguins$ python3 -m venv .venv
```

This will create a new directory called `.venv` in the current working directory. Remark that the name and location of this directory can be chosen freely, but `.venv` is a common convention.

## exploring the virtual environment

Take a look at the contents of the `.venv` directory (the `-F` option shows directories with a trailing slash, executables with a star and symbolic links with an `@`):

```console
student@linux:~/penguins$ ls -F .venv/
bin/  include/  lib/  lib64@  pyvenv.cfg
```

- The `bin/` directory contains (a symbolic link to) a Python interpreter as well as the `pip` package manager, and some helper scripts to set up the environment.
- The `lib/` directory contains the installed packages for this virtual environment. Currently, only `pip` is available, but later, we will install other packages. `lib64/` is a symbolic link to `lib/`.
- The `include/` directory does not contain any files for now and is not relevant for our purposes. We won't discuss it further.
- The `pyvenv.cfg` file contains configuration information about the virtual environment.

Take a look at the contents of the several directories and files mentioned above to get an idea of their structure.

```console
student@linux:~/penguins$ ls -F .venv/bin/
activate  activate.csh  activate.fish  Activate.ps1  pip*  pip3*  pip3.13*  python@  python3@  python3.13@
student@linux:~/penguins$ ls -F .venv/lib/python3.13/site-packages/
pip/  pip-25.1.1.dist-info/
```

## activating the virtual environment

To activate the virtual environment, you can use the `activate` script located in the `bin/` directory. For Bash (and similar shells), you can run the command in the example below. If you are using a different shell, use the appropriate `activate` script.

```console
student@linux:~/penguins$ source .venv/bin/activate
(.venv) student@linux:~/penguins$
```

Be sure to take a look at the contents of the activate script to see what it does. It will define some environment variables such as `PATH` and `PYTHONHOME`.

Once the virtual environment is activated, your shell prompt will change to indicate that you are now working inside the virtual environment. Inside this environment , the `python3` and `pip` commands will point to the versions located inside the virtual environment, rather than the system-wide versions.

```console
(.venv) student@linux:~/penguins$ which python3
/home/student/penguins/.venv/bin/python3
(.venv) student@linux:~/penguins$ which pip
/home/student/penguins/.venv/bin/pip
```

This is the reason why we used the shebang `#!/usr/bin/env python3` in the demo script. When you run the script as `./penguins.py`, the system will use the `python3` interpreter that is found first in the `PATH`, which will be the one from the virtual environment when it is activated. If you had used the path to the system-wide Python interpreter (e.g., `#!/usr/bin/python3`), it would not have access to the packages installed in the virtual environment.

Did you notice that the `activate` script is *not* executable? This is intentional. Running the script as you would a normal command would create a subshell. All changes to variables would be lost when exiting the subshell. By sourcing the script, the changes are made in the *current* shell. By not making the script executable, it prevents you from accidentally running it as a normal command. It will also not turn up when you use tab-completion to look for commands.

## dependency management

If we try to run the demo script now, it will fail because the required packages are not installed yet.

```console
(.venv) student@linux:~/penguins$ ./penguins.py
Traceback (most recent call last):
  File "/home/student/penguins/penguins.py", line 6, in <module>
    import seaborn as sns;
    ^^^^^^^^^^^^^^^^^^^^^
ModuleNotFoundError: No module named 'seaborn'
```

Let's install the required packages (and their dependencies) using `pip`:

```console
(.venv) student@linux:~/penguins$ pip install seaborn scikit-learn
Collecting seaborn
[... a lot of output omitted ...]
Successfully installed ...
```

The directory `.venv/lib/python3.13/site-packages/` will now contain subdirectories for the installed packages as well as their dependencies. You can also use `pip list` to see the installed packages (and their versions):

```console
(.venv) student@linux:~/penguins$ pip list
Package         Version
--------------- -------
contourpy       1.3.3
cycler          0.12.1
...
scikit-learn    1.7.2
scipy           1.16.2
seaborn         0.13.2
...
```

Let's try to run the demo script again:

```console
(.venv) student@linux:~/penguins$ ./penguins.py 
Regression line: mass = -5780.8314 + 49.6856 x fl_length
(.venv) student@linux:~/penguins$ ls -l output/
total 84
-rw-rw-r-- 1 student student 83284 Oct 22 13:02 penguins_flipper_mass.png
```

It works! The script printed the regression line coefficients and created the plot in the `output/` directory.

## reproducibility

If we want to share this project with a co-worker, or run the code on another system, we need to ensure that this virtual environment with all its dependencies can be reproduced.

One way to achieve this is by using a `requirements.txt` file, which lists all the packages and their versions installed in the virtual environment. You can create this file using the following command:

```console
(.venv) student@linux:~/penguins$ pip freeze > requirements.txt
```

This will create a `requirements.txt` file in the current directory that lists all installed packages and their versions. The contents of the file will look something like this:

```text
contourpy==1.3.3
cycler==0.12.1
...
scikit-learn==1.7.2
scipy==1.16.2
seaborn==0.13.2
six==1.17.0
...
```

You can edit this file if you want to add or remove specific packages, but usually, you would keep it as is to ensure exact reproducibility. You can then share this file with others, who can create a new virtual environment and install the same packages. Let's test this by deactivating the environment, deleting all files except the script and the `requirements.txt`, and recreating the environment from scratch.

```console
(.venv) student@linux:~/penguins$ deactivate
(.venv) student@linux:~/penguins$ deactivate
student@linux:~/penguins$ rm output/*
student@linux:~/penguins$ rm -rf .venv/
student@linux:~/penguins$ ls -la 
total 20
drwxrwxr-x 3 student student 4096 Oct 22 13:17 .
drwx------ 7 student student 4096 Oct 22 13:02 ..
drwxrwxr-x 2 student student 4096 Oct 22 13:16 output
-rwxrwxr-x 1 student student 1087 Oct 22 12:28 penguins.py
-rw-rw-r-- 1 student student  316 Oct 22 13:13 requirements.txt
```

The only remaining files are the script and the `requirements.txt` file. Now, let's recreate the virtual environment and install the dependencies from the `requirements.txt` file.

```console
student@linux:~/penguins$ python3 -m venv .venv
student@linux:~/penguins$ source .venv/bin/activate
(.venv) student@linux:~/penguins$ pip install -r requirements.txt 
Collecting contourpy==1.3.3
[... a lot of output omitted ...]
Successfully installed ...
(.venv) student@linux:~/penguins$ ./penguins.py 
Regression line: mass = -5780.8314 + 49.6856 x fl_length
(.venv) student@linux:~/penguins$ ls output/
penguins_flipper_mass.png
```

This works as expected! We were able to recreate the virtual environment and run the script successfully, producing the same output.

## deploying a Python workload with Docker

A common way to deploy applications nowadays is by using (Docker) containers. Containers provide a lightweight and portable way to package and run applications, including their dependencies. Let's build a Docker image that contains our demo script and its virtual environment.

Create a file called `Dockerfile` in the `penguins/` directory with the following contents:

```Dockerfile
FROM python:3.13-slim

ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv "${VIRTUAL_ENV}"
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"

# Install dependencies:
COPY requirements.txt .
RUN pip install -r requirements.txt

# Run the application:
COPY penguins.py .
CMD [ "python", "penguins.py" ]
```

This Dockerfile does the following:

- It starts with the official Python 3.13 slim image as the base image.
- It creates a virtual environment in the `/opt/venv` directory inside the container.
- It copies the `requirements.txt` file into the container and installs the dependencies into the virtual environment.
- It copies the `penguins.py` script into the container.
- Finally, it sets the command to run the script when the container starts.

An argument can be made that using a virtual environment inside a container is redundant, but with this approach, we ensure that the application runs in a consistent environment, regardless of where it is deployed.

To build the Docker image, first clean up the `output/` directory and virtual environment again!

```console
(.venv) student@linux:~/penguins$ deactivate
student@linux:~/penguins$ rm -rf .venv/ output/*
student@linux:~/penguins$ ls -F
Dockerfile  output/  penguins.py*  requirements.txt
```

Now, build the Docker image using the following command:

```console
student@linux:~/penguins$ docker build -t penguins-app .
[+] Building 23.7s (10/10) FINISHED                  docker:default
[... a lot of output omitted ...]
student@linux:~/penguins$ docker image ls
REPOSITORY     TAG       IMAGE ID       CREATED          SIZE
penguins-app   latest    223d19ca828f   30 seconds ago   657MB
```

Now, you can run the Docker container using the following command:

```console
student@linux:~/penguins$ docker run --rm -v "$PWD/output":/output penguins-app
Regression line: mass = -5780.8314 + 49.6856 x fl_length
student@linux:~/penguins$ ls output/
penguins_flipper_mass.png
```

The `--rm` option tells Docker to remove the container after it exits, and the `-v "$PWD/output":/output` option mounts the `output/` directory from the host machine into the container, so that the generated plot can be saved there and preserved after the container is deleted.

We see that the container ran successfully and produced the expected output!

