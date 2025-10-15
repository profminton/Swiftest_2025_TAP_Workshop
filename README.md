![Swiftest logo](_images/swiftest_social_preview.svg)

# Welcome to Swiftest!
Swiftest is the most recent member of the Swift family of n-body integrators. Swiftest was developed at Purdue University as a more user-friendly alternative to the [Swift](https://www2.boulder.swri.edu/~hal/swift.html) and [Swifter](https://www2.boulder.swri.edu/swifter/) software packages. Swiftest also has a number of performance-enhancing features that make it faster for many types of problems than its progenitors. A unique feature of Swiftest is the new collisional fragmentation model, called Fraggle. This is a powerful new tool that can realistically model collisions between massive bodies. 

This two hour workshop is organized into two parts. In hour 1, I will introduce you to the Swiftest project through it's Python front-end, where you can initialize, run, and process a set of basic simulations related to solar system dynamics. In hour 2, I will introduce you to the Fortran back-end, and show you more advanced concepts, such as writing custom force calculations, as well as how to contribute to the Swiftest project on GitHub.

## Learning Objectives
1. Create a Swiftest simulation using the Python frontend. 
2. Analyze simulation output using [Xarray](https://docs.xarray.dev/en/stable/index.html).
3. Customize the Fortran backend and compile the project locally.
4. Submit issues, feature requests, documentation and examples, and bugfixes to GitHub. 


## Instructions
Detailed instructions on how to install Swiftest can be found in the online document pages for Swiftest [here](https://swiftest.readthedocs.io/en/latest/getting-started-guide/index.html). As I will be showcasing some of the Swiftest functionality inside a Jupyterlab Notebook, I have provide some more specific instructions for setting up the environment here.

For hour 1, we will use the latest pre-compiled public release version of the code, which is available for Linux and MacOS as a Python package.  

To begin with, please clone this repository to your local machine:

```bash
$ git clone https://github.com/profminton/Swiftest_2025_TAP_Workshop.git
$ cd Swiftest_2025_TAP_Workshop
```

If you have previously cloned the repository, be sure to update it in case there are any changes:

```bash
$ git pull
```

### Hour 1: Install Jupyter Lab and Swiftest
My preferred method for managing packages is `venv`. If you are more comfortable with some other tool, like `conda`, `poetry`, `uv`, etc, feel free to use that. 

Here I will install a local virtual environment using Python 3.13 with a Jupyter kernel.

```bash
$ python3.13 -m venv venv
$ . venv/bin/activate
$ pip install swiftest jupyterlab
$ ipython kernel install --user --name=TAP_Swiftest
```

Then we can fire up Jupyter lab and run simulations.

```bash
$ jupyter lab &
```

Be sure to activate the `TAP_Swiftest` kernel.

### Hour 2: Install a development environment
For this section we will leave Jupyter Lab behind and move to a proper IDE. My preferred IDE is [Visual Studio Code](https://code.visualstudio.com/download), with the following extensions: C/C++ Extension Pack, Python and Python Debugger, Modern Fortran, Remote Development.

Now clone the [Swiftest GitHub repository](https://github.com/MintonGroup/swiftest). If you've already cloned it, be sure to pull any updates.

Next, you will need to prepare your machine for development. See [here](https://swiftest.readthedocs.io/en/latest/getting-started-guide/index.html#required-dependencies) for detailed instructions on installing dependencies and tools on various platforms.

