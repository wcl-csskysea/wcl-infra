#! /usr/bin/env python3
# -*- coding: utf-8 -*- 
from ast import arg
import re,os,sys,json
import argparse
import string,random,copy
import FortigateApi
from send_gmail import Mail

if sys.version_info[0] < 3:
    reload(sys)
    sys.setdefaultencoding('utf8')
else:
    import importlib
    importlib.reload(sys)


dict_user_email_list = []
characters = list(string.ascii_letters + string.digits + "!@#$%^&*()")


def generate_random_password():
	## length of password from the user
    length = 16
	## shuffling the characters
    random.shuffle(characters)
	## picking random characters from the list
    password_list = []
    for i in range(length):
	    password_list.append(random.choice(characters))
	## shuffling the resultant password
    random.shuffle(password_list)
    final_pass = "".join(password_list)
    return final_pass

def init_user_email_list(users=[],emails=[]):
    '''
    get all inputs(users,email address) from cli,and generate passwords.
    '''

    user_counts = len(users)
    user_email_dict = {'user':'','email':'','password':''}
    for i in range(0,user_counts):
        user_email_dict['user'] = users[i]
        user_email_dict['email'] = emails[i]
        user_email_dict['password'] = generate_random_password()
        dict_user_email_list.append(user_email_dict.copy())
    print(dict_user_email_list)

class FortientVPNCreator(object):

    def __init__(self):
        self.ipplusport = "10.10.0.1:5443"
        self.vdom = "root"
        self.admin = os.getenv('FTG_ADMIN')
        self.adminpwd = os.getenv('FTG_ADMIN_PASSWORD')
        self.fg = FortigateApi.Fortigate(ip=self.ipplusport,vdom=self.vdom,user=self.admin,passwd=self.adminpwd)
        self.group_name = ""
        self.memberlist = []

    def addusers(self,username_list):
        for user in username_list:
            vpn_pass = generate_random_password()
            self.fg.AddUserLocal(user,vpn_pass,'password')

    def getusers(self):
        user_list = []
        raw_user_list = json.loads(self.fg.GetUserLocal())['results']
        for each_dict in raw_user_list:
            user_list.append(each_dict['name'])
        print(user_list)
        return user_list 

    def adduser(self,username,vpn_pass):
        init_user_list = self.getusers()
        rc = 0
        if username in init_user_list:
            print('username %s has existed!\n' % username)
            rc = 255
              
        else:
            # vpn_pass = generate_random_password()
            self.fg.AddUserLocal(username,vpn_pass,'password')
        return rc

    def initMembersList(self,group_name):
        '''
        to get exist members.
        '''
        old_members = self.fg.GetGroup(group_name)
        self.memberlist = json.loads(old_members)['results'][0]['member'] 


    def adduser2MemberList(self, user_name):
        '''
        to add new member.
        '''
        member_dict = {'q_origin_key':user_name,'name':user_name}
        self.memberlist.append(member_dict.copy())
    
    def setUsers2Group(self, group_name,members):
        self.fg.SetUser2Group(group_name,members)
       

def main(fgt_groupname=''):
    # step 1: get username+email address for each user.
    ftg = FortientVPNCreator()
    mail = Mail()
    # group_name = 'ssl-vpn-created-by-bot'
    group_name = fgt_groupname
    ftg.initMembersList(fgt_groupname)

    for each_account in dict_user_email_list:
        #create vpn account in forient firewall.
        rc = ftg.adduser(each_account['user'],each_account['password'])
        if rc == 0:
            # combine existing vpn account members and new joined user together.
            ftg.adduser2MemberList(each_account['user'])   
            #send notification email one by one.
            mail.send(each_account['email'],each_account['user'],each_account['password'])          
    # put all vpn members under some group in forient firewall.
    ftg.setUsers2Group(group_name,ftg.memberlist)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='wiredcraft vpn account provision')
    parser.print_usage()
    parser.add_argument('-u','--usersname',type=str,nargs='+',help='Input username please!')
    parser.add_argument('-m','--usersemail',type=str,nargs='+',help='Input user email please!')
    parser.add_argument('-g','--groupname',type=str,default='ssl-vpn-created-by-bot')
    args = parser.parse_args()
    init_user_email_list(args.usersname,args.usersemail)
    main(args.groupname)
