# latexauto
Latex Automation System

Latexauto is a set of latex script generation tool. The environment prerequisites includes:
- Bash (I use bash in most cases. You may transform it to csh if you wish)
- TexLive / xelatex
- at (It is not a must but it helps a lot)

## Directory Hierarchy
|Name | Contents|
|----:|:--------|
|script| All active components. Make sure you run scripts under the root directory.|
|tex| Where generated tex placed. It should be empty if you wish to fork your work.|
|pdf| Where generated pdf placed. It should be empty if you wish to fork your work.|

## Components
### dirtree
Generate a graphic directory tree. Decsriptions can be added according to ".dirtag" of each directory. 
Only the first line of the dirtag is included in the graph. 

Usage: ./script/dirtree.sh directory max-level

- e.g. ./script/dirtree.sh /usr/local 2
This generates the directory tree graph of "/usr/local" for a maximum level of 2.

![Run example](https://github.com/coolpay64/latexauto/blob/master/dirtree.PNG?raw=true)

### buildtodo
Generate a todo list under a directory hierarchy. Each directory with a .todo file is represented as individual section.
If .dirtag exists in a directory. First line of the .dirtag is attached to the section header.
Example .todo file is available at the root directory.

Usage: ./script/buildtodo.sh directory 

- e.g. ./script/buildtodo.sh .
This generates all todo items under current.

## Contact
These scripts are just ad-hoc stuff. There must be bugs.
Feel free to let me know through GitHub / Mail : coolpay64@gmail.com

##Licenese
<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="CC-BY 4.0" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a><br /><span xmlns:dct="http://purl.org/dc/terms/" property="dct:title">Latexauto</span>is created by<a xmlns:cc="http://creativecommons.org/ns#" href="https://github.com/coolpay64/" property="cc:attributionName" rel="cc:attributionURL">Coolpay64(KH Wong)</a>, licensed under <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">CC-BY 4.0</a>.<br />
