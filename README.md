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



##Licenese
<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="CC-BY 4.0" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a><br /><span xmlns:dct="http://purl.org/dc/terms/" property="dct:title">Latexauto</span>is created by<a xmlns:cc="http://creativecommons.org/ns#" href="https://github.com/coolpay64/" property="cc:attributionName" rel="cc:attributionURL">Coolpay64(KH Wong)</a>, licensed under <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">CC-BY 4.0</a>.<br />
