require 'pony'

module ItTools
  class MailTools
    def sendSmtpSslMail(from,to,subject,body,user, password, host, port)
      Pony.mail(:to => to, :from => from, :subject => subject, :body => body, :via => :smtp, :smtp => {
                  :host => host,
                  :port => port,
                  :user => user,
                  :password => password,
                  :auth => :login})
    end
    def sendMailToBeehive(from,to,subject,body,user, password)
      sendSmtpSslMail(from,to,subject,body,user, password, "stbeehive.oracle.com", 465)
    end
  end
end


                
                
