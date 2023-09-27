class ApplicationController < ActionController::Base
  before_action :authenticate_admin!

  protected

  def after_sign_in_path_for(resource)
    if resource.is_a?(Admin)
      new_admin_entry_log_path
    else
      root_path
    end
  end
end
