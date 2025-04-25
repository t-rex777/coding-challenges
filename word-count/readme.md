# Challenge link

[Word Count Challenge](https://codingchallenges.substack.com/p/coding-challenge-1)

## How to create a custom command

### Add permission access for the executable file

- `chmod +x linux-wc.rb`
- chmod is a Unix/Linux command that stands for "change mode". It's used to change the permissions of files and directories.
- syntax `chmod [permissions] [file]`

### Create a symbolic link

- `sudo ln -s "$(pwd)/linux-wc.rb" /usr/local/bin/ccwc`
- sudo: This runs the command with superuser (administrator) privileges, which is needed because we're creating a file in the system directory /usr/local/bin
- ln: This is the command to create links (shortcuts) in Unix/Linux
- -s: This flag means we're creating a "symbolic link" (also called a "soft link"). A symbolic link is like a shortcut that points to another file
"$(pwd)/linux-wc.rb":
- pwd is a command that prints the current working directory
$(pwd) executes the pwd command and uses its output
This gives us the full path to your linux-wc.rb file
- ccwc is the name we want to use to run the command