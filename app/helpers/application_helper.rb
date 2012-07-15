module ApplicationHelper
  
  # these next four helper functions needed for devise views
  def resource_name
    :user
  end
  def resource_class
    User
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
