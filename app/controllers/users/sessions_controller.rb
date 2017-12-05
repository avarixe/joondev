class Users::SessionsController < Devise::SessionsController
  before_action :set_system
  respond_to :js

  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate(auth_options)
    if resource && resource.active_for_authentication?
      sign_in(resource_name, resource)
      redirect_to after_sign_in_path_for(resource)
    else
      respond_to do |format|
        format.js
      end
    end
  end

  private

  def set_system
    @system = 'MyFifa'
  end
end
