class StoresController < ApplicationController
  append_view_path 'app/views/stores'
  before_action :authorize
  before_action :primary_only, only: [:edit, :update, :destroy, :delete, :manage]
  before_action :is_admin?, only: [:destroy, :verify]
  before_action :set_store, only: [:show, :edit, :update, :destroy, :verify, :manage, :pricing, :confirm, :change_token]
  before_action :data_completed?, only: [:show]

  def index
    if admin_signed_in?
      @stores = Store.all
    else
      @stores = current_manager.stores
    end
  end

  def show
  end

  def new
    @store = current_user.stores.new
    @store.contacts.build
  end

  def edit
  end

  def create
    @store = current_user.stores.new(store_params)

    if @store.save
      redirect_to @store, notice: 'Store was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if params[:store][:schedules_attributes]
      @store.schedules.destroy_all
    end

    if @store.update(store_params)
      if params[:store][:schedules_attributes]
        redirect_to [@store, :schedules], notice: 'schedules successfully updated.'
      else
        redirect_to @store, notice: 'Store was successfully updated.'
      end
    else
      render action: 'edit'
    end
  end

  def confirm
    uri = URI("http://maps.googleapis.com/maps/api/geocode/json")
    params = { address: @store.address, sensor: false }
    uri.query = URI.encode_www_form(params)

    @response = Net::HTTP.get_response(uri)
  end

  def delete
    @store.set(deleted: true)
    redirect_to stores_url, notice: 'Store was successfully deleted.'
  end

  def destroy
    @store.destroy
    redirect_to stores_url, notice: 'Store was successfully destroyed.'
  end

  def verify
    @store.update_attribute(:verified, true)
    redirect_to stores_url, notice: 'Store was successfully verified.'
  end

  def manage
  end

  def change_token
    @store.change_mobile_token
    redirect_to [@store, :waiters], notice: "QR changed successfully"
  end

private
  def store_params
    params.require(:store).permit!#(:name, :short_name, :description, :address, :web, :facebook, :twitter, :city, :phone, :loc, :category, :time_zone, :payment, :billing_date, :tipping, :tip_amount, :hidden, contacts_attributes: [ :name, :position, :email, :phone ], schedules_attributes: [ :day, :active, :start_time, :end_time ])
  end

  def data_completed?
    @store.loc.nil? ? redirect_to([:confirm, @store], notice: "Completa tus datos") : true
  end
end
