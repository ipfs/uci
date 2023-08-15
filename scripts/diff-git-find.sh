#!/bin/bash

pushd "$TARGET" > /dev/null

# Store the outputs of the commands in temporary files
git ls-tree --full-tree --name-only -r HEAD | grep 'go\.mod$' > tmp_git.txt
find . -type f -name 'go.mod' | sed 's|^./||' | sort > tmp_find.txt

# Use diff to compare the outputs
diff tmp_git.txt tmp_find.txt | tee -a tmp_diff.txt

# Check if the diff output is empty
length=$(wc -l < tmp_diff.txt)

# Cleanup the temporary files
rm tmp_git.txt tmp_find.txt tmp_diff.txt

# Check the length to see if the files are identical
if [ $length -eq 0 ]; then
    echo "Both commands return the same set of files."
    exit 0
else
    echo "The commands return different sets of files."
    exit 1
fi

popd > /dev/null
