class Accounts::RegistrationsController < Devise::RegistrationsController
private
  def sign_up_params
    params.require(:manager).permit!
  end
end
