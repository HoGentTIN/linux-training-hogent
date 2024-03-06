## Solutions

1. Download the code by clicking the green button "Code" on the GitHub page and selecting "Download ZIP". Unpack the ZIP file in a directory of your choice and rename it to e.g. `vagrant-demo-env` (or any other name you like).

    Open a terminal in this directory and run `git init .` to initialize a new Git repository. This is not strictly necessary, but it's a good habit to keep your work under version control. You can now add the files to the repository with `git add .` and commit them with `git commit -m "Initial commit"`.

2. Open `vagrant-hosts.yml` and add the following content. Check the latest versions of the bae boxes on <https://app.vagrantup.com/bento> and update the version numbers if necessary!

    ```yaml
    ---
    - name: alma
      box: bento/almalinux-9
      ip: 192.168.56.11

    - name: fedora
      box: bento/fedora-latest
      ip: 192.168.56.12

    - name: debian
      box: bento/debian-12.4
      ip: 192.168.56.21

    - name: ubuntu
      box: bento/ubuntu-22.04
      ip: 192.168.56.22
    ```

3. Copy the file `srv001.sh` to `alma.sh`, `fedora.sh`, etc. and add any commands for installing packages or configuring the system.

    Don't forget to add the new files to the Git repository and commit your changes.
