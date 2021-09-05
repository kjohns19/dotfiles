# dotfiles

A few configuration dotfiles I use in my setup. This also has some scripts that I use. Run `install.py` to create symbolics links in your home directory to use them.


## classmake

Create an empty C++ class

```
$ classmake sample::SampleClass
$ ls
sample_class.cpp  sample_class.hpp

$ cat sample_class.hpp
#pragma once

namespace sample {

class SampleClass
{
  public:
    // TODO

  private:
    // TODO
};

}  // close namespace sample

$ cat sample_class.cpp
#include <sample_class.hpp>

namespace sample {

// TODO

}  // close namespace sample
```

Run `classmake --help` for usage.

## check-format

Quickly check all C++ files for format issues using clang-format

```
$ ls
sample_class.cpp  sample_class.hpp

$ check-format
Checking 2 files...
sample_class.hpp needs formatting
```

Run `check-format --help` for usage.
