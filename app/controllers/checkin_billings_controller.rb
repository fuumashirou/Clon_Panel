class CheckinBillingsController < ApplicationController
  before_filter :set_store
  def discount
    @bill = $redis.hgetall("Bill:#{params[:id]}")
  end

  def apply_discount
    $redis.hset("Bill:#{params[:id]}", "discount", params[:discount])

    redirect_to [@store, :orders]
  end
end
