#!bin/sh

#
### nag people by mail if they have not committed to a git repo recently
#
### - dependencies: 'nail' to send the email
### - usage:
### $ git-nag "/path/to/git/repo" "author@example.com" "4hours"

# user-editable VARIABLES
source "/etc/default/git-nag" # passwords and defaults go here
NAG_SUBJECT="[git-nag] Bad Girl!"

# PARAMS to VARIABLES
GIT_REPO="$1"
GIT_REPO_NAME="$(basename "$GIT_REPO").git"
AUTHOR_EMAIL="$2"
TIMEFRAME="$3"

#
## FUNCTIONS

### this function defines how the Nag is send -- should be costumized to work
function send_nag(){
    if [[ "$(which nail)" ]]
    then
        cat "$NAG_MESSAGE" | nail -v -S from="$NAG_SENDER" -S smtp -s "$NAG_SUBJECT" -S smtp="$NAG_SMTP_HOST" -S smtp-auth-user="$NAG_SMTP_USER" -S smtp-auth-password="$NAG_SMTP_PASSWD" "$AUTHOR_EMAIL" && rm "$NAG_MESSAGE"
    fi
}

### define usage function
usage(){
    echo "Error: Missing parameters!"
    echo 'Usage: '$0' "/path/to/git/repo" "author@example.com" "4hours"'
    exit 1
}

### show usage and exit if params are missing
#[[ "$1" -eq 0 ]] && usage; [[ "$2" -eq 0 ]] && usage; [[ "$3" -eq 0 ]] && usage

#
## GIT-NAG ## ######################################################################

# check work
cd "$GIT_REPO"
git pull
git log --author="$AUTHOR_EMAIL" --after={"$TIMEFRAME"} --exit-code && STATUS="BAD" || STATUS="GOOD"
echo ""$STATUS"!"

# nag and send to culprit
if [[ "$STATUS" == "BAD" ]]
then
    NAG_MESSAGE=$(mktemp)
    echo "You have not commited anything to "$GIT_REPO_NAME" in the last "$TIMEFRAME"!" > "$NAG_MESSAGE"
    send_nag
fi

exit 0