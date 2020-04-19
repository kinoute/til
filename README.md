# Today I Learned

A collection of concise write-ups on small things I learn day to day across a
variety of languages and technologies.

# Categories

* [unix](unix/README.md)

# Contribute

You can easily add a new article by running the `contribute.sh` bash script like:

```bash
./contribute.sh
```

It will:

1. Ask you to enter the category of the new article. If it doesn't exist, it will create a new folder.
2. Ask you to enter the title of the article (like "How to see my public IP")
3. Create a markdown file in the category folder and open it with vim directly in insert mode at the end of the file.
4. Once you're done writing the article, save it and close vim with the command `:wq`.
5. It will update the main `README.md` file in case you created a new category.
6. It will update the category `README.md` file to append a link to the new article you just wrote.

You're now ready to commit and push the new article!

## About

Forked from:

* [jbranchaud/til](https://github.com/jbranchaud/til)
* [thoughtbot/til](https://github.com/thoughtbot/til)
* [Today I Learned by Hashrocket](https://til.hashrocket.com)
* [jwworth/til](https://github.com/jwworth/til)
* [thoughtbot/til](https://github.com/thoughtbot/til)
