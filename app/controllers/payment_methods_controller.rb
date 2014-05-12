class PaymentMethodsController < ApplicationController
  before_action :set_store, except: :notification
  before_action :set_payment_method, only: [:show, :edit, :update]

  def index
    @payment_methods = @store.payment_methods
  end

  def show
  end

  def new
    method = PaymentTypes::Main.find(params[:method])
    if method.nil? || !method.active
      redirect_to [current_store, :payment_methods], alert: 'Method not supported.'
    else
      @payment_method = @store.payment_methods.build({}, PaymentKhipu)
    end
  end

  def edit
  end

  def create
    if params[:payment_method][:method] == "khipu"
      @payment_method = @store.payment_methods.build({
        email:              params[:payment_method][:email],
        first_name:         params[:payment_method][:first_name],
        last_name:          params[:payment_method][:last_name],
        identifier:         params[:payment_method][:identifier],
        bussiness_category: params[:payment_method][:bussiness_category],
        bussiness_name:     params[:payment_method][:bussiness_name],
        phone:              params[:payment_method][:phone],
        address_line_1:     params[:payment_method][:address_line_1],
        address_line_2:     params[:payment_method][:address_line_2],
        address_line_3:     params[:payment_method][:address_line_3]
      }, PaymentKhipu)
    else
      redirect_to [@store, :payment_methods], notice: 'Method not supported.'
    end

    if @payment_method.save
      redirect_to [@store, :payment_methods], notice: 'Payment method was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @payment_method.update(payment_method_params)
      redirect_to @payment_method, notice: 'Payment method was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
  end

  def notification
    if params[:method] == "khipu"
      result = Khipu::UpdatePaymentNotificationUrl
      if result
        billing = Billing.where(id: result).first
        billing.verified = true
        billing.save
        return true
      end
    else
      redirect_to root_path, alert: 'Method not supported.'
    end
  end

  private
    def set_payment_method
      @payment_method = @store.payment_methods.find(params[:id])
    end

    def payment_method_params
      params.require!
    end
end
