#! /usr/bin/python
# -*- coding: utf-8 -*- 
import re,os,sys,json
import string,random,copy
import smtplib, ssl
import FortigateApi
from email.mime.multipart import MIMEMultipart
from jinja2 import Environment, FileSystemLoader
from email.mime.text import MIMEText

reload(sys)

sys.setdefaultencoding('utf8')

dict_user_email_list = []

characters = list(string.ascii_letters + string.digits + "!@#$%^&*()")

def print_usage():
    msg = '''
    usage: wcl-vpn-account-distribution.py add <username>/<email address>
    for example: wcl-vpn-account-distribution.py add victor.chen/victor.chan@wiredcraft.com
    of course you can input multiple users once.
    '''
    print(msg)

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



class ArgsParser(object):

    '''
    add which accounts need to be created into queue, after created,set state to done.
    '''
    def __init__(self):
        pass

    def addUserEmailList(self,accounts_list=[]):
        raw_vpn_accounts_list = []
        raw_vpn_accounts_list.extend(accounts_list)
        dict_vpn_account = {}

        for each_account in raw_vpn_accounts_list:
            dict_vpn_account['user']= each_account.split('/')[0]
            dict_vpn_account['email'] = each_account.split('/')[1]
            dict_user_email_list.append(dict_vpn_account.copy())
        print(dict_user_email_list)

    def remove(self,accounts_list=[]):
        pass

    def updateState(self,state):
        pass
    
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
       
class Mail(object):

    def __init__(self):
        self.port = 465
        self.smtp_server_domain_name = "smtp.gmail.com"
        self.sender_mail = ""
        self.password = ""

    def send(self, email_addr,username,password):
        # ssl_context = ssl.create_default_context()
        # service = smtplib.SMTP_SSL(self.smtp_server_domain_name, self.port, context=ssl_context)
        service = smtplib.SMTP_SSL(self.smtp_server_domain_name, self.port)
        service.login(self.sender_mail, self.password)
        
        root = os.path.dirname(os.path.abspath(__file__))
        templates_dir = os.path.join(root, 'templates')
        env = Environment( loader = FileSystemLoader(templates_dir) )
        template = env.get_template('email_template.htm') 
        filename = os.path.join(root, 'html', '{}.html'.format(username))
        with open(filename, 'w') as fh:
            fh.write(template.render(
            username = username,
            password = password
    ))

        with  open(filename,"rb") as fd:
            mail_body = fd.read()

        message = MIMEText(mail_body, 'html', 'utf-8')
        
        message['From'] = self.sender_mail
        message['To'] = email_addr
        message['Subject'] = "vpn account distribution"
        try:
            result = service.sendmail(self.sender_mail, email_addr, message.as_string())
        except:
            print("send email failed!")
        service.quit()

def main():
    # step 1: get username+email address for each user.
    ftg = FortientVPNCreator()
    mail = Mail()
    group_name = 'testgroup'
    ftg.initMembersList('ssl-vpn')

    for each_account in dict_user_email_list:
        vpn_pass = generate_random_password()
        each_account['password'] = vpn_pass
        ftg.adduser(each_account['user'],vpn_pass)
        ftg.adduser2MemberList(each_account['user'])        

    ftg.setUsers2Group(group_name,ftg.memberlist)

    for each_account in dict_user_email_list:
        mail.send(each_account['email'],each_account['user'],each_account['password'])

if __name__ == '__main__':

    if len(sys.argv) < 3:
        print_usage()
        sys.exit()
    if sys.argv[1] == "add":
        ArgsParser().addUserEmailList(sys.argv[2:])

    main()
