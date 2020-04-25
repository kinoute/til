# Function to extract all archive formats 

When we have to extract data from an archive, we can easily get lost depending
of the archive format. There is `tar`, `gunzip`, `unzip` and many more UNIX
commands to deal with archives. But we lack a unique command/function that
could extract any archive no matter its format.

We can create a function that, depending of the archive format, will call the
correct unix command to extract files from it.

```bash
# add it to your .bashrc or similar

function extract () {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1     ;;
      *.tar.gz)    tar xzf $1     ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar e $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xf $1      ;;
      *.tbz2)      tar xjf $1     ;;
      *.tgz)       tar xzf $1     ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)     echo "'$1' cannot be extracted via extract()" ;;
       esac
   else
       echo "'$1' is not a valid file"
   fi
}
```

That way, no headache anymore to remember the correct UNIX command to use. Just
type `extract archive_filename` and it will automatically call the correct
command for you.
