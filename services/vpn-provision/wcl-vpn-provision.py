#! /usr/bin/python
# -*- coding: utf-8 -*- 
from ast import arg
import re,os,sys,json
import argparse
import string,random,copy
import FortigateApi
from .send_gmail import Mail

reload(sys)
sys.setdefaultencoding('utf8')

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
    for i in range(0,user_counts-1):
        user_email_dict['user'] = users[i]
        user_email_dict['email'] = emails[i]
        user_email_dict['password'] = generate_random_password()
        dict_user_email_list.append(user_email_dict.copy())

class FortientVPNCreator(object):

    def __init__(self):
        self.ipplusport = ""
        self.vdom = ""
        self.admin = ""
        self.adminpwd = ""
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
        if username in init_user_list:
            print('username %s has existed!\n' % username)
             
        else:
            # vpn_pass = generate_random_password()
            self.fg.AddUserLocal(username,vpn_pass,'password')

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
       

def main():
    # step 1: get username+email address for each user.
    ftg = FortientVPNCreator()
    mail = Mail()
    group_name = 'testgroup'
    ftg.initMembersList('ssl-vpn')

    for each_account in dict_user_email_list:
        #create vpn account in forient firewall.
        ftg.adduser(each_account['user'],each_account['password'])
        # combine existing vpn account members and new joined user together.
        ftg.adduser2MemberList(each_account['user'])        
    # put all vpn members under some group in forient firewall.
    ftg.setUsers2Group(group_name,ftg.memberlist)
    # send notification email for vpn provision one by one.
    for each_account in dict_user_email_list:
        mail.send(each_account['email'],each_account['user'],each_account['password'])

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--usersname',type=str,nargs='+')
    parser.add_argument('--usersemail',type=str,nargs='+')
    args = parser.parse_args()
    init_user_email_list(args.usersname,args.usersemail)
    main()
