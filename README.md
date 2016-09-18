# dotfiles
A few configuration dotfiles I use in my setup. This also has some scripts that I use. Run setup_links.sh to create symbolics links in your home directory to use them.

## classmake
Create an empty C++ class.

```
$ classmake SampleClass
$ ls
sample_class.cpp  sample_class.hpp
$ cat sample_class.hpp 
#ifndef INCLUDED_SAMPLE_CLASS_HPP
#define INCLUDED_SAMPLE_CLASS_HPP

class SampleClass
{
public:
    // TODO
private:
    // TODO
};

#endif // INCLUDED_SAMPLE_CLASS_HPP
$ cat sample_class.cpp 
#include <sample_class.hpp>

// TODO

```

Run `classmake -h` for usage.

## swap
Swap two files

```
$ cat a
A
$ cat b
B
$ swap a b
$ cat a
B
$ cat b
A
```

Run `swap -h` for usage.

## vimopen
Open files in multiple tabs/splits using vim

```
$ vimopen file1 file2 'file3|file4'
# Opens file1 and file2 in separate tabs. In a 3rd tab open file3 and file4 in splits
$ vimopen 'file1|file2|-d' 'file3|file4|-d'
# Compares file1 with file2 and file3 with file4
```

Run `vimopen -h` for usage.
