title=$1
slug=`echo $title | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g'`
date_slug=`date +"%Y-%m-%d"`
file="$date_slug-$slug.md"

echo "Creating post $file"
post_file="_posts/$file"
touch post_file
mkdir assets/posts/$file
echo "---" >> $post_file
echo "layout: post" >> $post_file
echo "title: $title" >> $post_file
echo "author: David Hatanian" >> $post_file
echo "---" >> $post_file
echo "" >> $post_file

atom $post_file
