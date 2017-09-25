class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :js

  # POST /resource
  def create
    super do |resource|
      return respond_to do |format|
        format.js {
          resource.persisted? ?
            render(:create) :
            render('shared/errors', locals: { object: resource })
        }
      end
    end
  end

  # PUT /resource
  def update
    super do |resource|
      return respond_to do |format|
        format.js {
          resource.previous_changes.any? ?
            render(:update) :
            render('shared/errors', locals: { object: resource })
        }
      end
    end
  end
end