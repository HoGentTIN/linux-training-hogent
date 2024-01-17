# solution: groups

1\. Create the groups tennis, football and sports.

    groupadd tennis ; groupadd football ; groupadd sports

2\. In one command, make venus a member of tennis and sports.

    usermod -a -G tennis,sports venus

3\. Rename the football group to foot.

    groupmod -n foot football

4\. Use vi to add serena to the tennis group.

    vi /etc/group

5\. Use the id command to verify that serena is a member of tennis.

    id (and after logoff logon serena should be member)

6\. Make someone responsible for managing group membership of foot and
sports. Test that it works.

    gpasswd -A (to make manager)

    gpasswd -a (to add member)
