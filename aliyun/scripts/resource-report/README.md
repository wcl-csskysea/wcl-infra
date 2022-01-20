# aliyun-scripts-resource-report

Report Aliyun resource billing information by customer, environment and product via email.


## Prerequisites

* Bash: to run the script
* [Aliyun CLI](https://github.com/aliyun/aliyun-cli): to get data from aliyun
* [jq](https://stedolan.github.io/jq/): to mangle json data from aliyun
* [mustache](https://mustache.github.io/): email template engine
* [apprise](https://github.com/caronc/apprise): to send email


## How to run the script

First, you will need to set up required environment variables, you can find an example at `.env.example`.
The following example assumes environment variables have been set in `.env` and current working directory is at `resource-report`.


```sh
# Source and export environment variables
set -a
. .env

# Run the script
./generate-and-send-report
```


## Project structure

```
.
├── billing-by-tags-and-products.jq   # jq script to mangle Aliyun API response
├── billing-report.csv.mustache       # csv template used in email attachment
├── billing-report.html.mustache      # email template
└── generate-and-send-report          # entrypoint script
```
