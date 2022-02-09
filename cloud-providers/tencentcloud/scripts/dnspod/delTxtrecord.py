import json
from secret import ID,Key
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

    Domain = "wiredcraft.cn"
    SubDomain = "_acme-challenge.teleport"
    RecordType = "TXT"

    req = models.DescribeRecordListRequest()
    params = {
        "Domain": Domain,
        "Subdomain": SubDomain,
        "RecordType": RecordType,
        "Limit": 3000
    }

    req.from_json_string(json.dumps(params))
    #Looking for record
    resp = client.DescribeRecordList(req)
    data = json.loads(resp.to_json_string())['RecordList']

    if len(data) > 1:
        print('The subdomain %s are more than two records, please handle manually. ' % SubDomain)
        exit()
    else:
        for i in data:
            print('Found a record %s' % i)
            RecordId = i['RecordId']
            req = models.DeleteRecordRequest()
            paramsdel = {
                "Domain": Domain,
                "RecordId": RecordId
            }
            req.from_json_string(json.dumps(paramsdel))
            #Delete record
            resp = client.DeleteRecord(req)
            print(resp.to_json_string())

except TencentCloudSDKException as err:
    print(err)