# Python `matplotlib` Package Notes

## Set the rendering engine

When I first tried to use matplotlib the first time I encountered the error:

> RuntimeError: Python is not installed as a framework. 

This is a common, ongoing problem that seems to have been around for years.  It has to do with the default rendering engine on Mac OS not being appropriate for matplotlib:

[Here's a good article that talks about it](http://www.wirywolf.com/2016/01/pyplot-in-jupyter-inside-pyenv-on-el-capitan.html).

**Approach #1**

NOTE: This didn't work for me.

On the Mac you need to manually set the backend rendering engine (not sure why they couldn't do this for you).

Figure out the location of matplotlib:

```bash
$ python -c "import matplotlib; print(matplotlib.__path__)"
```

Go to the root of the lib and add the necessary config file:

```bash
$ vi matplotlibrc
# => add: "backend: TkAgg"
```

**Approach #2**

NOTE: This approach did work for me.

You can also set the rendering engine in your Python script:

```python
import matplotlib as mpl
mpl.use('TkAgg')
from matplotlib import pyplot
```

## Save output as SVG file

```python
import matplotlib as mpl
mpl.use('TkAgg')
from matplotlib import pyplot as plt
import numpy as np
x = np.arange(0,100,0.00001)
y = x*np.sin(2*np.pi*x)
plt.plot(y)
plt.savefig("test.svg", format="svg")
```
