class PagesController < ApplicationController
  def index
    Rails.env.production? ? redirect_to(account_session_path) : true
  end

  def dashboard
  end

  def contact
  end
end
