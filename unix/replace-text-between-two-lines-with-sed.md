# Replace text between two lines with `sed` 

You can easily replace a text between two lines with the great `sed` command.
Let's say we have a given file called `example.txt like this:

```
BEGIN
hello
world
how
are
you
END
```

We can replace the text between `BEGIN` and `END` by using the folling command:

```bash
sed -e '/BEGIN/,/END/c\BEGIN\nNEW TEXT\nEND' example.txt
```

It should output:

```
BEGIN
NEW TEXT
END
```

`/BEGIN/,/END/` selects a range of text that starts with `BEGIN` and ends with `END`. Then `c\` command is used to replace the selected range with `BEGIN\nNEW TEXT\nEND`.

Source: https://stackoverflow.com/a/5179968/6373370 
