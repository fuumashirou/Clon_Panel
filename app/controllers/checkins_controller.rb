class CheckinsController < ApplicationController
  before_action :set_store

  def index
  end

  def show
    @checkin = RedisCheckin.find(params[:id])
  end

  def change
    checkin = RedisCheckin.find(params[:id])
    result  = params[:merge] ? checkin.merge_table(params[:table_id]) : checkin.change_table(params[:table_id])

    if result
      redirect_to [@store, :tables], notice: "Checkin #{params[:merge] ? 'merged' : 'moved'} succeed."
    else
      redirect_to [@store, :tables], alert: "Checkin cant be #{params[:merge] ? 'merged' : 'moved'}."
    end
  end

  def leave
    checkin = RedisCheckin.find(params[:id])
    if checkin.checkout
      redirect_to [@store, :tables], notice: 'Checkin was successfully updated.'
    else
      redirect_to [@store, :tables], alert: 'Users already leave.'
    end
  end

  def leave_all
    checkins = RedisCheckin.find_by({ store_id: params[:store_id] })

    checkins.each do |checkin|
      checkin.checkout
    end
    redirect_to [@store, :tables], notice: 'All Checkins removed.'
  end
end
