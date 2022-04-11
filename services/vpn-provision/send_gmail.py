#! /usr/bin/python
import smtplib, ssl

class Mail:

    def __init__(self):
        self.port = 465
        self.smtp_server_domain_name = "smtp.gmail.com"
        self.sender_mail = ""
        self.password = ""

    def send(self, subject, content):
        ssl_context = ssl.create_default_context()
        service = smtplib.SMTP_SSL(self.smtp_server_domain_name, self.port)
        service.login(self.sender_mail, self.password)
        result = service.sendmail(self.sender_mail, self.sender_mail, 
        "Subject: {subject}\n{format}".format(subject=subject,content=content))

        service.quit()

