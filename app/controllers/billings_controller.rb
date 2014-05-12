class BillingsController < ApplicationController
  append_view_path 'app/views/stores'
  before_action :primary_only
  before_action :set_store
  before_action :set_billing, only: :show

  def index
  end

  def show
  end

private
  def set_billing
    @billing = @store.billings.find(params[:id])
  end
  def billing_params
    params.require(:billing).permit(:date, :amount, :paid)
  end
end
