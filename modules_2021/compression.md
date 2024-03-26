# Compression

## About compression


Files can be compressed in two distinct forms named **lossy
compressions** and **lossless compression**. With **lossy compression**
it is impossible to recreate the original file, an example of this is a
**.mp3** file or a **.jpg** file.

With **lossless compression** it is always possible to recreate the
original file (or files). Examples of **lossless compression** are
**.gz** files and **.flac** files.

In this chapter we only discuss **lossless compression** of files.

## gzip


One of the most popular tools for compressing files on Linux is
**gzip**. In the example below we use the **gzip** command on a copy of
the **/etc/services** file.

    paul@debian10:~$ cp /etc/services .
    paul@debian10:~$ ls -l services
    -rw-r--r-- 1 paul paul 18774 Jul 28 15:09 services
    paul@debian10:~$ gzip services
    paul@debian10:~$ ls -l services.gz
    -rw-r--r-- 1 paul paul 7307 Jul 28 15:09 services.gz
    paul@debian10:~$

Using **gzip** on this small text file made it shrink in size from 18774
bytes to 7307 bytes, as shown by the two **ls -l** commands.

Notice that when using **gzip** on a file, the name of the file is
appended with **.gz** .

## zmore


You cannot use tools like **cat**, **more**, **head**, **tail** or
**grep** on the compressed file (please don’t try this). But you can use
**zmore** as shown in this example.

    paul@debian10:~$ file services.gz
    services.gz: gzip compressed data, was "services", last modified: Sun Jul 28 13:09:58 2019, from Unix, original size 18774
    paul@debian10:~$ zmore services.gz
    # Network services, Internet style
    #
    # Note that it is presently the policy of IANA to assign a single well-known
    # port number for both TCP and UDP; hence, officially ports have two entries
    # even if the protocol doesn't support UDP operations.
    #
    # Updated from https://www.iana.org/assignments/service-names-port-numbers/service-names-p
    ort-numbers.xhtml .
    #
    # New ports will be added on request if they have been officially assigned
    # by IANA and used in the real-world or are needed by a debian package.
    # If you need a huge list of used numbers please install the nmap package.

    tcpmux          1/tcp                           # TCP port service multiplexer
    echo            7/tcp
    echo            7/udp
    discard         9/tcp           sink null
    discard         9/udp           sink null
    systat          11/tcp          users
    daytime         13/tcp
    daytime         13/udp
    netstat         15/tcp
    qotd            17/tcp          quote
    msp             18/tcp                          # message send protocol
    --More--

## zcat


You can also use **zcat** to have the whole file scrolling by on the
display. Luckily we can combine the **zcat** command with commands like
**head** and **tail**. See the example below for how to use **tail**
with **zcat**.

    paul@debian10:~$ zcat services.gz | tail -4
    tfido           60177/tcp                       # fidonet EMSI over telnet
    fido            60179/tcp                       # fidonet EMSI over TCP

    # Local services
    paul@debian10:~$

We will explain the **"|"** symbol in the Redirection chapter. For now
understand that the screenshot above shows the last four lines of the
compressed **services** file.

## zgrep


And you can use the **zgrep** command to search for strings in the
compressed **services.gz** file, as is shown in this example.

    paul@debian10:~$ zgrep http services.gz
    # Updated from https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xhtml .
    http            80/tcp          www             # WorldWideWeb HTTP
    https           443/tcp                         # http protocol over TLS/SSL
    http-alt        8080/tcp        webcache        # WWW caching service
    http-alt        8080/udp
    paul@debian10:~$

## gzip -l


The **gzip -l** option (that is the lowercase letter L from **l**ist)
allows you to view the uncompressed size of a **.gz** file before
uncompressing it. In this example we use **gzip -l** on the
**all.txt.gz** file that was downloaded some chapters ago.

    paul@debian10:~$ gzip -l all.txt.gz
             compressed        uncompressed  ratio uncompressed_name
                 332067             2903154  88.6% all.txt
    paul@debian10:~$

Compressing multiple files in one file (with **tar** for example) is
discussed in the backup chapter.

## gunzip


Compressed files can be uncompressed again with **gunzip**. The
screenshot below shows how to uncompress the **services.gz** file back
to its original state. The **.gz** file extension is removed by
**gunzip**.

    paul@debian10:~$ ls -l services.gz
    -rw-r--r-- 1 paul paul 7307 Jul 28 15:09 services.gz
    paul@debian10:~$ gunzip services.gz
    paul@debian10:~$ ls -l services
    -rw-r--r-- 1 paul paul 18774 Jul 28 15:09 services
    paul@debian10:~$

## bzip2 - bunzip2 - bzcat - bzmore - bzgrep


Another popular compressions tool on Linux is **bzip2**. It is generally
slower than **gzip** but compresses better. In the screenshot below we
use **bzip2** and its associated commands **bunzip2**, **bzcat**,
**bzmore**, and **bzgrep**.

    paul@debian10:~$ bzip2 services
    paul@debian10:~$ ls -l services.bz2
    -rw-r--r-- 1 paul paul 6966 Jul 28 15:09 services.bz2
    paul@debian10:~$ bzcat services.bz2 | tail -4
    tfido           60177/tcp                       # fidonet EMSI over telnet
    fido            60179/tcp                       # fidonet EMSI over TCP

    # Local services
    paul@debian10:~$ bzgrep http services.bz2
    # Updated from https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xhtml .
    http            80/tcp          www             # WorldWideWeb HTTP
    https           443/tcp                         # http protocol over TLS/SSL
    http-alt        8080/tcp        webcache        # WWW caching service
    http-alt        8080/udp
    paul@debian10:~$ bunzip2 services.bz2
    paul@debian10:~$ ls -l services
    -rw-r--r-- 1 paul paul 18774 Jul 28 15:09 services
    paul@debian10:~$

## Cheat sheet

<table>
<caption>Compression</caption>
<colgroup>
<col style="width: 27%" />
<col style="width: 72%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>command</p></td>
<td style="text-align: left;"><p>explanation</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>gzip foo</p></td>
<td style="text-align: left;"><p>Compress the <strong>foo</strong> file
with gzip.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>gzip -l foo.gz</p></td>
<td style="text-align: left;"><p>Display information about the
compressed <strong>foo.gz</strong> file.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>zmore foo.gz</p></td>
<td style="text-align: left;"><p>Display the compressed
<strong>foo.gz</strong> file page by page.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>zcat foo.gz</p></td>
<td style="text-align: left;"><p>Display the complete
<strong>foo.gz</strong> file.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>zgrep foo bar.gz</p></td>
<td style="text-align: left;"><p>Show the lines containing the string
<strong>foo</strong> from the compressed <strong>bar.gz</strong>
file.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>gunzip foo.gz</p></td>
<td style="text-align: left;"><p>Uncompress the <strong>foo.gz</strong>
file.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>bzip2 foo</p></td>
<td style="text-align: left;"><p>Compress the <strong>foo</strong> file
with bzip2.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>bzmore foo.bz2</p></td>
<td style="text-align: left;"><p>Display the compressed
<strong>foo.bz2</strong> file page by page.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>bzcat foo.bz2</p></td>
<td style="text-align: left;"><p>Display the complete
<strong>foo.bz2</strong> file.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>bzgrep foo bar.bz2</p></td>
<td style="text-align: left;"><p>Show the lines containing the string
<strong>foo</strong> from the compressed <strong>bar.bz2</strong>
file.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>bunzip2 foo.bz2</p></td>
<td style="text-align: left;"><p>Uncompress the <strong>foo.bz2</strong>
file.</p></td>
</tr>
</tbody>
</table>

Compression

## Practice

1.  Copy the **/usr/share/dict/words** file to your home directory.

2.  Verify the size of the **~/words** file.

3.  Use **gzip** to compress the **~/words** file.

4.  Again verify the size of the file.

5.  Is the word **evening** present in this compressed file?

6.  Display the last ten lines of **~/words.gz** .

7.  Uncompress the **~/words.gz** file.

8.  Repeat all of the above but use **bzip2** instead of **gzip**.

## Solution

1.  Copy the **/usr/share/dict/words** file to your home directory.

        cp /usr/share/dict/words ~

2.  Verify the size of the **~/words** file.

        ls -l ~/words

3.  Use **gzip** to compress the **~/words** file.

        gzip ~/words

4.  Again verify the size of the file.

        ls -l ~/words.gz

5.  Is the word **evening** present in this compressed file?

        zgrep evening ~/words.gz

6.  Display the last ten lines of **~/words.gz** .

        zcat ~/words.gz | tail

7.  Uncompress the **~/words.gz** file.

        gunzip ~/words.gz

8.  Repeat all of the above but use **bzip2** tools instead of **gzip**.

        ls -l ~/words
        bzip2 ~/words
        ls -l ~/words.bz2
        bzgrep evening ~/words.bz2
        bzcat ~/words.bz2 | tail
        bunzip2 ~/words.bz2
