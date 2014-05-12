class CurrenciesController < ApplicationController
  before_action :is_admin?
  before_action :set_currency, only: [:show, :edit, :update, :destroy]

  def index
    @currencies = Currency.all
  end

  def show
  end

  def new
    @currency = Currency.new
  end

  def edit
  end

  def create
    @currency = Currency.new(currency_params)

    if @currency.save
      redirect_to @currency, notice: 'Currency was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @currency.update(currency_params)
      redirect_to @currency, notice: 'Currency was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @currency.destroy
    redirect_to currencies_url, notice: 'Currency was successfully destroyed.'
  end

private
  def set_currency
    @currency = Currency.find(params[:id])
  end
  def currency_params
    params.require(:currency).permit(:currency)
  end
end
