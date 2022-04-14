## Introduction

To provision vpn account for newcomer.


## Script process

- get inputs from cli that user name and user email which is needed in the process of provision vpn account.
- invoke fortient gateway vpn user api to create vpn account(user/password) according to inputs.
- create a members-list(combine the existing group members and new created member)
- invoke fortient gateway vpn api to set the members-list to some group.

- render html template of email with username and password, and invoke gmail api to send notification email.

## Usage

1. set necessary environments

```
source envsetting
```
then execute the following commandline:

`python3 wcl-vpn-provision.py --usersname xxx --usersemail xxx@xxx.com`

## Notices:

- Although `wcl-vpn-provision.py` support multiple arguments input, but after test, the notification emails seems can't be sent in such case, so suggest input one user once.

- Because of gmail security limitation, we need to set the sender's gmail some setting to send notification email successfully.