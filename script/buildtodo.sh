#!/bin/bash



tempfolder=$(mktemp -d /tmp/todolist-XXXXX)
tempfile="$tempfolder/todolist.tex"
temppdf="$tempfolder/todolist.pdf"

cat <<EOF >$tempfile
\documentclass[11pt,a4paper]{article}
\usepackage{wasysym}     
\usepackage{fancyvrb}
\setlength{\marginparwidth}{1.2in}
\let\oldmarginpar\marginpar
\renewcommand\marginpar[1]{\-\oldmarginpar[\raggedleft #1]%
  {\raggedright #1}}    

  \newenvironment{checklist}{%
    \begin{list}{}{}% whatever you want the list to be
      \setlength{\itemsep}{1.5ex}
      \setlength{\parskip}{0pt}
      \setlength{\parsep}{0pt}   
      \addtolength{\itemindent}{-2em} 
      \let\olditem\item
      \renewcommand\item{\olditem -- \marginpar{$\Box$} }
    \newcommand\checkeditem{\olditem -- \marginpar{$\CheckedBox$} }
  }{%
    \end{list}
  }   

  \RecustomVerbatimCommand{\VerbatimInput}{VerbatimInput}%
  {fontsize=\footnotesize,commandchars=\|\(\)}
\begin{document}
\title{Project To-Do List}
\author{Working Team}
\maketitle
EOF

fileList=$(find $1 -name ".todo" | sort )
for filename in $fileList; do
  if [ -s "$filename" ]; then
    if [ -f $(sed "s/todo$/dirtag/" <<< "$filename") ];then
      echo "\\section {" $( sed "s/\.todo$//" <<< "$filename") " - " $(head -n1 -q $(sed "s/todo$/dirtag/" <<< "$filename")) "}" >> "$tempfile"
    else 
      echo "\\section {" $( sed "s/\.todo$//" <<< "$filename") "}" >> "$tempfile"
    fi
    echo "\\begin{checklist}" >> "$tempfile"
    prevIsItem=-1
    transStarted=0
    while IFS= read -r line; do
      isCheckItem=0
      isItem=0
      if [[ "$line" =~ ^(\[x\]) ]]; then 
        isCheckItem=1
      fi
      if [[ "$line" =~ ^(\[ \]) ]]; then 
        isItem=1
      fi
      if [[ ("$isItem" -eq "1" )|| ("$isCheckItem" -eq "1" )]]; then 
        transStarted=1
      fi
      if [ "$transStarted" -eq "1" ]; then
        if [[ (("$isItem" -eq "1" )|| ("$isCheckItem" -eq "1" )) && ("$prevIsItem" -eq "0")]]; then 
          echo "\\end{Verbatim}"
        fi

        if [[ "$isCheckItem" -eq "1" ]]; then 
          sed -e "s/^\[x\]/\\\\checkeditem \\\\texttt{\\\\detokenize{/" -e "s/$/}}/" <<< "$line"
        elif [[ "$isItem" -eq "1" ]]; then 
          sed -e "s/^\[ \]/\\\\item \\\\texttt{\\\\detokenize{/" -e "s/$/}}/" <<< "$line"
        else
          if [[ "$prevIsItem" -eq "1" ]]; then 
            echo "\\begin{Verbatim}"
          fi
          echo "$line"
        fi

        if [[ (("$isItem" -eq "1" ) || ("$isCheckItem" -eq "1" ))]]; then 
          prevIsItem=1
        else
          prevIsItem=0
        fi
      fi
    done < "$filename" >> "$tempfile"
    if [[ ( "$transStarted" -eq "1" ) && ( "$prevIsItem" -eq "0" ) ]]; then
          echo "\\end{Verbatim}" >> "$tempfile"
    fi
    echo "\\end{checklist}" >> "$tempfile"
  fi
done

cat <<EOF >> "$tempfile"
\end{document}
EOF

xelatex -interaction nonstopmode --output-directory=$tempfolder "${tempfile}" >/dev/null 2>&1
xelatex -interaction nonstopmode --output-directory=$tempfolder "${tempfile}" 
cp $temppdf pdf/
cp $tempfile tex/
rm -rf $tempfolder
