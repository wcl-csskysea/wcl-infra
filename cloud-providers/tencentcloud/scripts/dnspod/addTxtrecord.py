#!/usr/bin/env python3
import json
import time
from secret import ID,Key
from os import environ
from tencentcloud.common import credential
from tencentcloud.common.profile.client_profile import ClientProfile
from tencentcloud.common.profile.http_profile import HttpProfile
from tencentcloud.common.exception.tencent_cloud_sdk_exception import TencentCloudSDKException
from tencentcloud.dnspod.v20210323 import dnspod_client, models

try:
    cred = credential.Credential(ID, Key)
    httpProfile = HttpProfile()
    httpProfile.endpoint = "dnspod.tencentcloudapi.com"

    clientProfile = ClientProfile()
    clientProfile.httpProfile = httpProfile
    client = dnspod_client.DnspodClient(cred, "", clientProfile)
    #get Value from certbot
    certbot_validation = environ["CERTBOT_VALIDATION"]

    req = models.CreateRecordRequest()
    params = {
        "Domain": "wiredcraft.cn",
        "SubDomain": "_acme-challenge.teleport",
        "RecordType": "TXT",
        "RecordLine": "默认",
        "Value": certbot_validation
    }
    req.from_json_string(json.dumps(params))
    resp = client.CreateRecord(req)
    print(resp.to_json_string())

    # Waiting for validation to take effect
    time.sleep(25)

except TencentCloudSDKException as err:
    print(err)