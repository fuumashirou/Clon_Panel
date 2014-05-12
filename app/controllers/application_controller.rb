class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_url
  # around_filter :user_time_zone, if: :current_store

  delegate :allow?, to: :current_permission
  helper_method :allow?

  def set_url
    @url = Rails.env.production? ? "https://api.twable.com" : "http://localhost:4000" # 192.168.0.176:4000"
  end

  def set_store
    if admin_signed_in?
      store_id = params[:store_id] ? params[:store_id] : params[:id]
      @store = Store.find(store_id)
    else
      if current_store.nil?
        redirect_to new_account_session_path, alert: "Sign in first."
      else
        @store = current_store
      end
    end
  end

  def is_primary?
    admin_signed_in? || manager_signed_in? ? true : false
  end

  def primary_only
    if admin_signed_in? || manager_signed_in?
      true
    else
      redirect_to current_store, alert: "Not allowed"
    end
  end

  def is_admin?
    if admin_signed_in?
      true
    else
      redirect_to root_path, alert: "Not allowed"
    end
  end

  def current_store
    if (admin_signed_in? || manager_signed_in?) && request.original_fullpath.split("/")[1] == "stores"
      store_id = params[:store_id].present? ? params[:store_id] : params[:id]
      @current_store ||= Store.find(store_id) if store_id
    elsif employee_signed_in?
      @current_store ||= current_user.store
    else
      nil
    end
  end

  def current_user
    if admin_signed_in?
      @current_user ||= current_admin
    elsif manager_signed_in?
      @current_user ||= current_manager
    elsif employee_signed_in?
      @current_user ||= current_employee
    else
      nil
    end
  end

  def account_signed_in?
    current_account ? true : false
  end
  helper_method :current_admin, :current_manager, :current_employee,
                :require_admin!, :require_manager!, :require_employee!,
                :is_primary?, :current_store, :current_user

  def current_permission
    @current_permission ||= Permission.new(current_user)
  end

  def authorize
    if !current_permission.allow?(params[:controller], params[:action])
      redirect_to root_url, alert: "Not authorize"
    end
  end

  def user_time_zone(&block)
    Time.use_zone(current_store.time_zone, &block)
  end

  def account_url
    return new_account_session_url unless account_signed_in?
    case current_account.class.name
    when "Admin"
      admin_root_url
    when "Manager"
      manager_root_url
    when "Employee"
      employee_root_url
    else
      root_url
    end if acoount_signed_in?
  end

private
  def after_sign_in_path_for(resource)
    # Unique MD5 key
    cookies["_validation_token_key"] = { value: Digest::MD5.hexdigest("#{session[:session_id]}:#{resource._id.to_s}"), domain: :all }
    # Store session data as JSON
    stored_session = { account_id: resource._id.to_s }
    stored_session[:store_id] = current_store._id.to_s if resource.class.name == "Employee"
    $redis.hset(
      "accountSessionStore",
      cookies["_validation_token_key"],
      JSON.generate(stored_session),
     )
    if resource.class.name == "Employee"
      return current_store
    else
      return stores_path
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    # Expire session in redis
    if cookies["_validation_token_key"].present?
      $redis.hdel("accountSessionStore", cookies["_validation_token_key"])
    end
    return root_path
  end

  def current_admin
    @current_admin ||= current_account if account_signed_in? and current_account.class.name == "Admin"
  end

  def current_manager
    @current_manager ||= current_account if account_signed_in? and current_account.class.name == "Manager"
  end

  def current_employee
    @current_employee ||= current_account if account_signed_in? and current_account.class.name == "Employee"
  end

  def admin_logged_in?
    @admin_logged_in ||= account_signed_in? and current_admin
  end

  def manager_logged_in?
    @manager_logged_in ||= account_signed_in? and current_manager
  end

  def employee_logged_in?
    @employee_logged_in ||= account_signed_in? and current_employee
  end

  def require_admin
    require_user_type(:admin)
  end

  def require_manager
    require_user_type(:manager)
  end

  def require_employee
    require_user_type(:employee)
  end

  def require_user_type(user_type)
    if (user_type == :admin and !admin_logged_in?) or
      (user_type == :managed and !manager_logged_in?) or
      (user_type == :employee and !employee_logged_in?)
      redirect_to root_path, status: 301, notice: "You must be logged in a#{'n' if user_type == :admin} #{user_type} to access this content"
      return false
    end
  end


end
