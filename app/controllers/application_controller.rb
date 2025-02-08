class ApplicationController < ActionController::Base
  include Authentication
  before_action :set_current_user
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private
  def set_current_user
    @user = Current.user
  end
end
