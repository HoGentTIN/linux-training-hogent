## practice: basic Unix tools

1. Explain the difference between these two commands. This question is
very important. If you don't know the answer, then look back at the
`shell` chapter.

    find /data -name "*.txt"

    find /data -name *.txt

2. Explain the difference between these two statements. Will they both
work when there are 200 `.odf` files in `/data` ? How about when there
are 2 million .odf files ?

    find /data -name "*.odf" > data_odf.txt

    find /data/*.odf > data_odf.txt

3. Write a find command that finds all files created after January 30th
2010.

4. Write a find command that finds all \*.odf files created in
September 2009.

5. Count the number of \*.conf files in /etc and all its subdirs.

6. Here are two commands that do the same thing: copy \*.odf files to
/backup/ . What would be a reason to replace the first command with the
second ? Again, this is an important question.

    cp -r /data/*.odf /backup/

    find /data -name "*.odf" -exec cp {} /backup/ \;

7. Create a file called `loctest.txt`. Can you find this file with
`locate` ? Why not ? How do you make locate find this file ?

8. Use find and -exec to rename all .htm files to .html.

9. Issue the `date` command. Now display the date in YYYY/MM/DD format.

10. Issue the `cal` command. Display a calendar of 1582 and 1752.
Notice anything special ?

