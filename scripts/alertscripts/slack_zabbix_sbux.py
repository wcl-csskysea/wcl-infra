#!/usr/bin/env python
import logging
import json
import os
import sys
from datetime import datetime
import requests


slack_username = "Zabbix"
url = "https://hooks.slack.com/services/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"
session = requests.Session()
session.mount("http://", requests.adapters.HTTPAdapter(max_retries=2))
session.mount("https://", requests.adapters.HTTPAdapter(max_retries=2))


logger = logging.getLogger('')
fh = logging.FileHandler(
    '/var/log/zabbix/%s.log' % os.path.basename(sys.argv[0])
)
fh.setLevel(logging.INFO)
logger.addHandler(fh)


def main():
    channel = sys.argv[1]
    title = sys.argv[2]
    params = "".join(sys.argv[3:])
    emoji = ":smile:"
    color = "good"

    if title[:7] == "PROBLEM":
        emoji = ":scream:"
        color = "danger"

    payload = {
        "channel": channel,
        "username": slack_username,
        "icon_emoji": emoji,
        "attachments": [
            {
                "title": title,
                "title_link": "",
                "color": color,
                "fields": [
                    {
                        "title": "Params:",
                        "value": params,
                        "short": True,
                    }
                ]
            }
        ]
    }
    payload_string = json.dumps(payload)
    try:
        result = session.post(url, data=payload_string, timeout=30)
    except requests.exceptions.Timeout:
        print "%s Error: Timeout" % datetime.now()
        logger.error("%s Error: Timeout" % datetime.now())
        return

    if result.content == "ok":
        print "%s Success: Notification sent successfully." % datetime.now()
        logger.error("%s Success: Notification sent successfully." % datetime.now())
    else:
        print "%s Error: %s" % (datetime.now(), result.content)
        logger.error("%s Error: %s" % (datetime.now(), result.content))


if __name__ == "__main__":
    main()
