# git-nag

###### nag people by mail if they have not committed to a git repo recently
    
---

## Synopsis

    git-nag "/path/to/git/repo" "author@example.com" "4hours"
    
Enter the git repository, git-pull from the default remote, ask git-log for if 
someone with the email "author@example.com" has committed anything in the last 4 hours.  
If no commits were found, send an email saying so to the same email address.


## Installation & Usage

git-nag depends on `nail` to send email. make shure it is installed (or change the script).

    $ [[ $(which nail) ]] && echo "HAZ nail" || echo "NO nail :("

next, populate `/etc/default/git-nag` with info on how to send the mails:

    NAG_SENDER="git-nag@example.com"
    NAG_SMTP_HOST="smtp.example.com:587"
    NAG_SMTP_USER="robot@example.com"
    NAG_SMTP_PASSWD="sUp3rsEcrETpaSSw0rD"
    
eg. like so:

    sudo sh -c 'echo -e "NAG_SENDER="git-nag@example.com" \nNAG_SMTP_HOST="smtp.example.com:587" \nNAG_SMTP_USER="robot@example.com" \nNAG_SMTP_PASSWD="sUp3rsEcrETpaSSw0rD"" > /etc/default/git-nag2'

git-nag is called with 3 parameters:

    git-nag "/path/to/git/repo" "author@example.com" "4hours"
    git-nag "/path/to/git/repo" "author@example.com" "5minutes"
    git-nag "/path/to/git/repo" "author@example.com" "2weeks"
    
Nobody wants to check manually, so it should be run from cron

    $ crontab -e
    # m h  dom mon dow   command
    0 12,16 * 8,9 1-5 git-nag "/path/to/git/repo" "author@example.com" "4hours" >/dev/null
    
This would run at 12 and 4pm, on every weekday in August and September, checking if someone with a matching email commited something in the 4 hours before the run.

I actually use it with [cronic](http://habilis.net/cronic/):

    0 12,16 * 8,9 1-5 cronic git-nag "/path/to/git/repo" "author@example.com" "4hours"
