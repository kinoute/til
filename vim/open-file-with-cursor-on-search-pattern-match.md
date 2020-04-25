# Open file with cursor on search pattern match 

Sometimes, you want to open a file and go to a specific line straight away. Imagine you're looking for something in a file with `grep`. In my case, I wanted to check if there was a rule in my `/etc/hosts` file for the _analytics.twitter.com_ address because I couldn't visit it.

```bash
grep "analytics\.twitter\.com" /etc/hosts
# 0.0.0.0 analytics.twitter.com
```

Indeed, I have one. Now I want to comment it to get my access back!  I could use `grep` with the `-n` argument to get the line number:

```bash
grep -n 'analytics\.twitter\.com' /etc/hosts
# 19838: 0.0.0.0 analytics.twitter.com
```

Now I can open the file `/etc/hosts` with vim and go directly to this line:

```bash
vim +19838 /etc/hosts
```

I could also open the file with vim and use its regex functionality to match the rule I'm looking for. **But there is a better approach:** you can combine the `grep` regex feature with vim's feature to open a file and go to a specific line:

```bash
# vim +/regex file
vim +/analytics\.twitter\.com /etc/hosts
```

It will open the `/etc/hosts` file and go to the first match of the given regex
pattern. Handy!


