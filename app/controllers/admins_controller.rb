class AdminsController < ApplicationController
  before_action :is_admin?

  def index
    @admins = Admin.all
  end

  def sidekiq
  end
end
