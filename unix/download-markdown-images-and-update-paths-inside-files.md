# Download markdown images and update paths inside files 

I like to use Github to organize all the notes and snippets I can find about a
specific subject when I'm doing, for example, a course.

One of the things I do the most is simply write down things in markdown files
and call it a day. Sometimes I even copy entire medium articles with their
respective images.

But I started to ask myself: What if tomorrow medium goes down? What if the
initial article gets deleted? The images inside my markdown notes would not
load anymore since I use the remote paths. If they disappear, some of my notes
don't make any sense anymore.

So I created a bash script to handle this problem as I don't want to copy all
the images manually. When started, the script is asked to:

1. Look inside `.md` and `.ipynb` files for markdown images (like
   `![](https://github.com/image.png)`)
2. Download the images found to the `images` folder
3. Change the image path inside the files to use the local image now

That way, I know that my notes have all the data locally and I'm not afraid of
losing informations displayed in images in case the remote host is down.

Here is the full script (gist available [here](https://gist.github.com/kinoute/c5db7ef24ead3bb8f2b780424075628d)):

```bash
#!/bin/bash

###################################################################
# Script Name    : get-md-images.sh
# Description    : Download all remote images written as markdown
#                  in our files and replace URLs by local path.
# Author         : Yann Defretin
# Email          : yann@defret.in
###################################################################

# stop on errors
set -e

# match any image written in markdown format
PATTERN="!\[.*\]\(https?[^]]+\.(png|gif|jpe?g|bmp|svg|tiff)\)"

echo "Checking if any md/ipynb file needs to download images..."

# get the files (markdown files and jupyter notebooks) that have markdown images
FILES=$(LC_ALL=C grep -r -s -i -l --include \*.md --include \*.ipynb -E "$PATTERN" .)

echo "$FILES" | while read -r FILE ; do

    # store the directory of the file
    FILE_DIRECTORY=$(dirname "$FILE")

    # Get the images markdown URLs
    URLS=$(grep -o -i -E "$PATTERN" "$FILE")

    # go to next file if no image urls were found
    [ -z "$URLS" ] && continue

    # create images folder if it's not here already
    [ ! -d "$FILE_DIRECTORY/images" ] && mkdir -p "$FILE_DIRECTORY/images"

    echo "Downloading images for $FILE..."

    echo "$URLS" | while read -r url ; do

        CORRECT_URL=$(echo -e ${url##*]} | tr -d '()')
        START_OF_CORRECT_URL="${CORRECT_URL%/*}"
        FILE_NAME=${CORRECT_URL##*/}

        # download images to the "images" folder
        [ ! -f "$FILE_DIRECTORY/images/$FILE_NAME" ] && wget "$CORRECT_URL" -P "$FILE_DIRECTORY/images/" -q

        # replace URL by the local path in the markdown file
        # macOS needs a blank -i argument
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' -e "s|$START_OF_CORRECT_URL|images|g" "$FILE"
        else
            sed -e "s|$START_OF_CORRECT_URL|images|g" "$FILE"
        fi

    done

done
```
