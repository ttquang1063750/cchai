class NotifierMailer < ApplicationMailer
  def new_email options
    mail(to: options[:to],
        cc: options[:cc],
        bcc: options[:bcc],
        from: options[:from],
        subject: options[:subject],
        body: options[:body],
        content_type: "text/html")
  end
end
