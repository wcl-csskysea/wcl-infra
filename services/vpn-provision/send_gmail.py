#! /usr/bin/python
import os
import smtplib, ssl
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from jinja2 import Environment, FileSystemLoader

class Mail(object):
    '''
    Description: send notificatin email through gmail.
    
    '''

    def __init__(self):
        self.port = 465
        self.smtp_server_domain_name = "smtp.gmail.com"
        self.sender_mail = os.getenv('EMAIL_SENDER')
        self.password = os.getenv('EMAIL_SENDER_PASSWORD')

    def send(self, email_addr,username,password):
        # ssl_context = ssl.create_default_context()
        # service = smtplib.SMTP_SSL(self.smtp_server_domain_name, self.port, context=ssl_context)
        service = smtplib.SMTP_SSL(self.smtp_server_domain_name, self.port)
        service.login(self.sender_mail, self.password)
        
        root = os.path.dirname(os.path.abspath(__file__))
        templates_dir = os.path.join(root, 'templates')
        render_dir = os.path.join(root, 'html')
        env = Environment( loader = FileSystemLoader(templates_dir) )
        template = env.get_template('email_template.htm') 
        if not os.path.exists(render_dir):
            os.mkdir(render_dir)
        filename = os.path.join(render_dir,'{}.html'.format(username))
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
        message['Cc'] = self.sender_mail
        message['Subject'] = "vpn account provisioin"
        try:
            result = service.sendmail(self.sender_mail, email_addr, message.as_string())
        except:
            print("send email failed!")
        service.quit()

