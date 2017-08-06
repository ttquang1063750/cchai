class BatchProcessRunningJob < ApplicationJob

  def perform
    BatchProcess.all.each do |bp|
      if bp.enable
        case bp.batch_process_type
        when "send_email"
          mail_options = Oj.load(bp.operation).with_indifferent_access
          bp.executed_at ||= Time.now
          if bp.executed_at < Time.now
            BatchProcessMailer.new_email(mail_options).deliver
            bp.executed_at = Time.now
            bp.enable = false
          end
          bp.save!
        end
      end
    end
  end
end
