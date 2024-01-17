# solution: git

1.Crate local project called `git_practice`.

    aschapelle@vaio3:~$ mkdir git_practice; cd git_practice

2.Create a project on `gitlab.com` to host a local project that you have
created.

3.The project should have `REAMDE.md` file as well as `TODO.md` file in
it.

    aschapelle@vaio3:~/git_practice$ touch REAMDE.md TODO.md

4.Write in `REAMDE.md` file description of the project and what you
think it might be.

    aschapelle@vaio3:~/git_practice$ echo "This is readme file for git_practice project" > README.md;
                aschapelle@vaio3:~/git_practice$echo "This is todo file for git_practice project" > TODO.md
        

5.Initialize your project with `git` command, setup your username, mail
and remote server.

    aschapelle@vaio3:~/git_practice$ git init 
            aschapelle@vaio3:~/git_practice$ git config user.name alex.schapelle
            aschapelle@vaio3:~/git_practice$ git config user.mail alex@vaiolabs.com
            aschapelle@vaio3:~/git_practice$ git remote add origin https://gitlab.com/url_to_your_project.git
        

6.Use `git push -u origin master` to send project saves to remote host.

            aschapelle@vaio3:~/git_practice$ git push -u origin master
        

7.Verify on `gitlab.com` that the project has been setup and is updated
with `REAMDE.md` and `TODO.md`.

8.Add git_hello.sh script that prints hello to username from its current
location.

    aschapelle@vaio3:~/git_practice$ git push -u origin master
        

9.Push the script to gitlab repository.

            aschapelle@vaio3:~/git_practice$ git push -u origin master
        
