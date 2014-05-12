class SelectionItemsController < ApplicationController
  before_action :set_store

  def stock
    @selections = @store.selections
    $redis.hset("Store:#{@store._id}:SelectionItem", params[:id], params[:stock])
    respond_to do |format|
      format.js
    end
  end
end
