## Introduction

To provision vpn account for newcomer.

## Prerequisite
- First, as vpn account admin, you need to use your gmail account to send notification email to user's gmail. to achieve this goal, you must enable your gmail smtp capabilty:

please go to https://myaccount.google.com/lesssecureapps and open this option "Allow less secure apps: ON"

## Script process

- get inputs from cli that user name and user email which is needed in the process of provision vpn account.
- invoke fortient gateway vpn user api to create vpn account(user/password) according to inputs.
- create a members-list(combine the existing group members and new created member)
- invoke fortient gateway vpn api to set the members-list to some group.

- render html template of email with username and password, and invoke gmail api to send notification email.


## Usage

1. set necessary environments

assign values in evesetting file
```
# FTG_ADMIN&FTG_ADMIN_PASSWORD: your login user and passwords in fortigate web-ui
export FTG_ADMIN=
export FTG_ADMIN_PASSWORD=

# EMAIL_SENDER&EMAIL_SENDER_PASSWORD: your gmail account and password which you use to send notificaiton email to users.
export EMAIL_SENDER=
export EMAIL_SENDER_PASSWORD=
```

then 
```
source ./git envsetting
```
finally execute the following commandline:

`python3 wcl-vpn-provision.py --usersname xxx --usersemail xxx@xxx.com`

## Notices:

- Although `wcl-vpn-provision.py` support multiple arguments input, but after test, the notification emails seems can't be sent in such case, so suggest input one user once.