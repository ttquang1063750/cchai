class Picture < ApplicationRecord
  include CopyCarrierwaveFile
  belongs_to :project
  before_save :set_image_by_params_image
  mount_uploader :image, ImageUploader

  attr_accessor :image_data

  validates_presence_of :name
  validates :name, uniqueness: {scope: :project_id}
  # validates :name, uniqueness: true

  def duplicate_image_data(original, project_id)
    copy_carrierwave_file(original, self, :image)
    self.project_id = project_id
    self.save!
  end

  private

  def set_image_by_params_image
    self.image = convert_image_data_to_image(image_data) unless image_data.nil?
  end

  def convert_image_data_to_image(image_data)
    temp_img_file = image_data.tempfile
    if self.project_id.present?
      img_params = {:filename => "#{self.name}-#{self.project_id}#{File.extname(temp_img_file)}",
                    :type => image_data.content_type, :tempfile => temp_img_file}
    else
      img_params = {:filename => "#{self.name}#{File.extname(temp_img_file)}",
                    :type => image_data.content_type, :tempfile => temp_img_file}
    end
    ActionDispatch::Http::UploadedFile.new(img_params)
  end
end
