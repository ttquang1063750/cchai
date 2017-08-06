class BatchProcessMailer < ApplicationMailer
  def new_email options
    mail(to: options[:to],
        from: options[:from],
        subject: options[:subject],
        body: options[:body],
        content_type: "text/html")
  end
end
