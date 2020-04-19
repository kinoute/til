# Open a file in insert mode with a new line 

A quick way with `vim` to edit a file to add new text at the end:

```bash
vim "+normal Go" +startinsert file.txt
```

It should open `file.txt` with `vim` directly in "insert mode" with a new line
added at the end of the file and the cursor on it.

Source: https://edunham.net/2015/01/29/vim_open_file_with_cursor_at_the_end.html
