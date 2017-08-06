class BatchProcess < ApplicationRecord
  enum batch_process_type: %i(send_email)
  belongs_to :project

  validates :name, uniqueness: {scope: :project_id, case_sensitive: false}

  %i(operation name).each do |e|
    validates_presence_of e
  end

end
