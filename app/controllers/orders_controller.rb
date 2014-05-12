class OrdersController < ApplicationController
  before_filter :set_store

  def index
  end

  def history
    @orders = @store.orders.order_by("ordered_at DESC")
  end

  def edit
    @items = []
    @order = $redis.hgetall("Order:#{params[:id]}")
    item_ids = $redis.smembers("i:Item:order_id:#{params[:id]}")
    item_ids.each do |item_id|
      @items << $redis.hgetall("Item:#{item_id}")
    end
  end

  def update
    order = $redis.hgetall("Order:#{params[:id]}")
    item_ids = params[:item_ids]
    item_ids.each do |item_id|
      $redis.del("Item:#{item_id}")
      $redis.srem("i:Item:order_id:#{order['id']}", item_id)
    end

    items_count = $redis.scard("i:Item:order_id:#{order['id']}")
    if items_count == 0
      $redis.del("Order:#{order['id']}")
      $redis.srem("i:Order:checkin_id:#{order['checkin_id']}", order["id"])
    end
    redirect_to [@store, :orders]
  end

  def print_order
    @order = $redis.hgetall("Order:#{params[:id]}")
    @items = []
    item_ids = $redis.smembers("i:Item:order_id:#{params[:id]}")
    item_ids.each do |item_id|
      @items << $redis.hgetall("Item:#{item_id}")
    end
    respond_to do |format|
      format.js
    end
  end

  def print_bill
    @bill = $redis.hgetall("Bill:#{params[:id]}")
    respond_to do |format|
      format.js
    end
  end
end
