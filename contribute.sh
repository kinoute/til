#!/bin/bash

###################################################################
# Script Name    : contribute.sh
# Description    : Adds a new article and updates the README files.
# Author         : Yann Defretin
# Email          : kinoute@gmail.com
###################################################################

# stop on errors
set -e

# make alias work in bash scripts
shopt -s expand_aliases

# macOS ships with a wrong sed version, use GNU sed
if [[ "$OSTYPE" == "darwin"* ]]; then
    [ ! -x "$(command -v gsed)" ] && echo "please install the GNU-version of sed: brew install gnu-sed" && exit 1
    alias sed='gsed'
fi

echo ""
echo "#####################"
echo "#  TODAY I LEARNED  #"
echo "#####################"
echo ""

echo -e "List of existing categories: \n"

# listing all existing categories
MD_CATEGORIES=$(ls -d */ | cut -f1 -d'/' | sed -r "s/^/* /")

echo -e "$MD_CATEGORIES \n"

read -p "- Enter the category (if it doesn't exist, folder will be created): " CATEGORY

# lower it
CATEGORY=$(echo "$CATEGORY" | tr '[:upper:]' '[:lower:]')

# create folder category if it doesn't exist
if [ ! -d "$CATEGORY" ]; then
    echo "$CATEGORY doesn't exist, creating folder.."
    mkdir -p "$CATEGORY"

    # updating the list of categories
    MD_CATEGORIES=$(ls -d */ | cut -f1 -d'/' | sed -r "s/^/* /")
fi

# enter article's title
read -p "- Enter the article title ($CATEGORY): " ARTICLE_TITLE

# generate markdown filename based on article title ("Hello World" -> "hello-world")
ARTICLE_FILE=$(echo "$ARTICLE_TITLE" | \
        iconv -t ascii//TRANSLIT | \
        sed -r 's/[~\^]+//g' | \
        sed -r 's/[^a-zA-Z0-9]+/-/g' | \
        sed -r 's/^-+\|-+$//g' | \
        sed -r 's/^-+//g' | \
        sed -r 's/-+$//g' | \
        tr A-Z a-z)

# avoid overwriting existing article
[ -f "$CATEGORY/$ARTICLE_FILE.md" ] && echo "A article with this name already exists. Exiting.." && exit 1

# create the markdown file and append the article's title
echo -e "# $ARTICLE_TITLE \n" > "$CATEGORY/$ARTICLE_FILE.md"

# open markdown file and enable insert mode at the end directly
echo ""
echo "Opening the markdown file with VIM..."

vim "+normal Go" +startinsert "$CATEGORY/$ARTICLE_FILE.md"

echo "Done writing the article."

# let's add the last article and categories in the main README for curious people
echo "Updating main README.md with last article and updated categories"

# link to the last article written and its date
LAST_ARTICLE="**[$(date +%d/%m/%Y)]:** [$ARTICLE_TITLE (***$CATEGORY***)]($CATEGORY/$ARTICLE_FILE.md)"
sed -i  "/# Last Article/,/# Categories/c\# Last Article\n\n$LAST_ARTICLE\n\n# Categories" README.md

# update categories in case a new one was introduced
MD_CATEGORIES=$(echo "$MD_CATEGORIES" | sed -r "s/^\* (\w+)$/* \[\1](\1\/README.md)/g")
MD_CATEGORIES=$(printf '%q' "$MD_CATEGORIES" | cut -d "'" -f 2)
sed -i  "/# Categories/,/# Contribute/c\# Categories\n\n$MD_CATEGORIES\n\n# Contribute" README.md

echo "Updated the main README file."

# regenerate category README.md to include link to new article
echo "Updating $CATEGORY README file..."

[ ! -f "$CATEGORY/README.md" ] && echo -e "# $CATEGORY \n" > "$CATEGORY"/README.md
echo "* [$ARTICLE_TITLE]($ARTICLE_FILE.md)" >> "$CATEGORY"/README.md

echo "Done updating $CATEGORY README file."

# we're done
echo "Article has been successfully created. Time to commit/push!"

