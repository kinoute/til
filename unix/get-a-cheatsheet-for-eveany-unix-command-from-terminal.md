# Get a cheatsheet for eveany UNIX command from terminal 

`man` can be useful when you want to learn more about a UNIX command. You can
see all the different arguments and options available. 

One con though: it lacks examples. Sometimes you want to see quickly what you
can do with a command, the most used scenarios that will cover 99% of your
needs.

This is where `cheat.sh` comes to the rescue. It's a website that gives a cheat
sheet of the most common scenarios for a lot of UNIX commands and programming
languages.

By using a simple bash function added in your `.bashrc` file (or `.zshrc` if you
use ZSH), you can query their website and get a cheat sheet for a given
command:

```bash
# in your .bashrc
function cheat() {
  curl cht.sh/$1
}
```

Then you can type in your terminal: `cheat mv` and it will output a cheat sheet
for the `mv` command:

```bash
# mv
# Move or rename files and directories.

# Move files in arbitrary locations:
mv source target

# Do not prompt for confirmation before overwriting existing files:
mv -f source target

# Prompt for confirmation before overwriting existing files, regardless of file permissions:
mv -i source target

# Do not overwrite existing files at the target:
mv -n source target

# Move files in verbose mode, showing files after they are moved:
mv -v source target
```

This function is limited. If you're looking for a more sophisticated command
line client, they made their own:
https://github.com/chubin/cheat.sh#command-line-client-chtsh

**Note:** You can also use this service from your favorite IDE:
https://github.com/chubin/cheat.sh#editors-integration

