class Api::V1::Admin::SiteInfoUsersSerializer < ActiveModel::Serializer
  attributes :id, :name, :email

  has_many :sites do |serializer|
    serializer.site_filter_by_site_info
  end

  has_many :site_infos do |serializer|
    serializer.site_infos_filter_by_project
  end

  def site_infos_filter_by_project
    object.site_infos.select { |e| e.project_id == instance_options[:project_id]}
  end

  def site_filter_by_site_info
    object.sites.select { |e| e.site_info_id == instance_options[:site_info_id]}
  end
end
