class Users::RegistrationsController < Devise::RegistrationsController
  before_action :set_system
  before_action :configure_permitted_parameters, if: :devise_controller?
  respond_to :js

  # POST /resource
  def create
    super do |resource|
      return respond_to do |format|
        format.js {
          unless resource.persisted?
            render 'shared/errors', locals: { object: resource }
          end
        }
      end
    end
  end

  # PUT /resource
  def update
    super do |resource|
      return respond_to do |format|
        format.js {
          unless resource.previous_changes.any?
            render 'shared/errors', locals: { object: resource }
          end
        }
      end
    end
  end

  protected

    def configure_permitted_parameters
      added_attrs = [:username, :email, :full_name, :password, :password_confirmation]
      devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
      devise_parameter_sanitizer.permit :account_update, keys: added_attrs << :current_password
    end

  private

  def set_system
    @system = 'MyFifa'
  end
end