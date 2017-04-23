class ApplicationController < ActionController::Base
before_action :configure_permitted_parameters, if: :devise_controller?
  def require_is_admin
    if !current_user.admin?
      flash[:alert] = '功利不够 还不能变身为大神'
      redirect_to root_path
    end
  end
  protected
   def configure_permitted_parameters
       devise_parameter_sanitizer.permit(:sign_up, keys: [:is_admin])
   end

end
