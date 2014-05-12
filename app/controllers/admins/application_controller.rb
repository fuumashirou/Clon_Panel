class Admins::ApplicationController < ApplicationController
  # layout 'admin'
  before_action :authenticate_admin!

  def authenticate_admin!
    return render_404 unless admin_signed_in?
  end
end
