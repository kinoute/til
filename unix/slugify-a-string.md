# Slugify a string 

Sometimes, you want to use a string to, for example, create a file with the
string being the filename. OSes are picky when it comes to filenames, some
characters are not accepted.

Therefore, you have to remove them or convert them to ones that are supported.
We can do this by combinin `iconv` and `sed` like this:

```bash
echo "Esperança do vôo do avião" | \
    iconv -t ascii//TRANSLIT | \
    sed -r 's/[~\^]+//g' | \
    sed -r 's/[^a-zA-Z0-9]+/-/g' | \
    sed -r 's/^-+\|-+$//g' | \
    sed -r 's/-$//g' | \
    tr A-Z a-z
```

It should output: `esperanca-do-voo-do-aviao`. It is useful to create URls too.

**Note:** on macOS, it won't work because macOS ships with a different
`sed` version. Either install the GNU-version by doing `brew install gnu-sed`
and replace `sed` by `gsed`:

```bash
 echo "Esperança do vôo do avião" | \ 
    iconv -t ascii//TRANSLIT | \
    gsed -r 's/[~\^]+//g' | \
    gsed -r 's/[^a-zA-Z0-9]+/-/g' | \
    gsed -r 's/^-+\|-+$//g' | \
    gsed -r 's/-$//g' | \
    tr A-Z a-z
```

Either change the command to use the `-E` argument instead of `-r`:

```bash
echo "Esperança do vôo do avião" | \
    iconv -t ascii//TRANSLIT | \
    sed -E 's/[~\^]+//g' | \
    sed -E 's/[^a-zA-Z0-9]+/-/g' | \
    sed -E 's/^-+\|-+$//g' | \
    sed -E 's/-$//g' | \
    tr A-Z a-Z
```

