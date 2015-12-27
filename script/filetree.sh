#!/bin/bash

#dirList=$(find ../../* -type d | sort | sed -e "s/\.\.\///g")
#oldName="."
#for dirName in $dirList; do
#  echo $dirName
#  oldName=$dirName
#done


tempfolder=$(mktemp -d /tmp/dirtree-XXXXX)
tempfile="$tempfolder/dirtree.tex"
maxLevelAccept=$2
if [ -z "$maxLevelAccept" ]; then
  maxLevelAccept="-1"
fi
# trap "rm $tempfile" 0 1 2 3 6 9 15

cat <<EOF >$tempfile
\documentclass{minimal}
\usepackage{tikz}
\usetikzlibrary{trees}
\begin{document}
\tikzstyle{every node}=[draw=black,thick,anchor=west]
\tikzstyle{selected}=[draw=red,fill=red!30]
\tikzstyle{optional}=[dashed,fill=gray!50]
\pdfpagewidth=PAGEWIDTHcm \pdfpageheight=PAGEHEIGHTcm
\begin{tikzpicture}[%
  grow via three points={one child at (0.0,0.0) and
  two children at (0.0,0.0) and (0.0,0.0)},
  edge from parent path={(\tikzparentnode.south) |- (\tikzchildnode.west)},
  every label/.append style={shift={(0,0-|descriptionheader.west)}}
  ]
  \node (descriptionheader) [draw=none, font=\bfseries] at (4,4ex) {Descriptions};
EOF

export -a scriptList=()
export -A typelist=()
level=0
maxLevel=0
dirLevelSearch(){
  local fPath="$1"
  local file=$(echo $fPath | sed -e "s/^.*\///")
  local fileLevel=0

  if [[ ( "$(find $fPath -maxdepth 1 -type d | wc -l)" -gt "1" ) && ( "$level" -le "$maxLevelAccept" || ( "$maxLevelAccept" -le "0" ) ) ]]; then
    fileLevel=$(($fileLevel+1))
    if [ "$level" -ne "0" ] ; then
      echo -n  "child { node "  >> $tempfile                                                                                  # Print directory name
      if [ -f "$fPath/.dirtag" ]; then                                                                                        # Print Directory Tag
        echo -n  "[label={right: " $(head -n1 -q "$fPath/.dirtag") " }]" >> $tempfile
      fi
      echo  "at (0.5, " $(echo $2 | awk '{printf "%4.3f",$1*-0.6}') ") {" $(echo $file | sed 's/_/\\_/g' ) " } " >> $tempfile # Print location and expend new node
    fi
    local head=1
    for nPath in $(find $fPath -maxdepth 1 -type d | sort); do
      if [ "$head" -eq "0" ] ; then
        level=$(($level + 1 ))
        dirLevelSearch "$nPath" "$fileLevel"
        fileLevel=$(($fileLevel+$?))
      fi
      head=0
    done
    if [ "$level" -ne "0" ] ; then
      echo  "}" >> $tempfile
    fi
  else
    if [ "$level" -ne "0" ] ; then
      echo -n  "child { node "  >> $tempfile                                                                                  # Print directory name
      if [ -f "$fPath/.dirtag" ]; then                                                                                        # Print Directory Tag
        echo -n  "[label={right: " $(head -n1 -q "$fPath/.dirtag") " }]" >> $tempfile
      fi
      echo "at (0.5, " $(echo $2 | awk '{printf "%4.3f",$1*-0.6}') ") {" $(echo $file | sed 's/_/\\_/g' ) " } }" >> $tempfile
      fileLevel=$(($fileLevel + 1))
    fi
  fi
  if [ "$level" -gt "$maxLevel" ]; then
    maxLevel=$level
  fi
  level=$(($level - 1 ))
  return $fileLevel
}

first=1
echo -n "\node " >> $tempfile
if [ -f "$1/.dirtag" ]; then                                                                                        # Print Directory Tag
  echo -n  "[label={right: " $(head -n1 -q "$1/.dirtag") " }]" >> $tempfile
fi
echo "{root}"  >>$tempfile
totalLevel=1
if [ "$(find $1 -maxdepth 1 -type d | wc -l)" -gt "1" ]; then
  dirLevelSearch $1 0
  totalLevel=$?
fi


IFS=$'\n\t '
echo ";" >> $tempfile
echo "\end{tikzpicture}"  >> $tempfile
echo "\end{document}"     >> $tempfile 

desLen=$(echo "Descriptions" | head $(find $1 -type f | sed -n -e "/\.dirtag/p") - -n1 -q | wc -L)
pageLen=$(echo $totalLevel | awk '{printf "%4.3f",$1*0.6+15}')
pageWidth=$(echo "$maxLevel $(find $1 -type d | wc -L) $desLen" | awk '{printf "%4.3f",$1*0.5+$2*0.2+$3*0.2+3}')

sed -e "s/PAGEHEIGHT/$pageLen/" -e "s/PAGEWIDTH/$pageWidth/" $tempfile > $tempfile".tmp"
mv $tempfile".tmp" $tempfile
xelatex -interaction nonstopmode --output-directory=$tempfolder "${tempfile}" >/dev/null 2>&1
xelatex -interaction nonstopmode --output-directory=$tempfolder "${tempfile}" 
cp $tempfolder/dirtree.pdf pdf/
cp $tempfolder/dirtree.tex tex/
rm -rf $tempfolder
