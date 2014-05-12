class MenuController < ApplicationController
  before_action :set_store
  before_action :primary_only


  def new
    @menu = Menu.new(store: @store._id)
  end

  def create
    if params[:file].original_filename.split(".")[-1] == "xlsx"
      @menu = Menu.new(store: @store._id)
      tmp = params[:file].tempfile
      file = File.join("public", params[:file].original_filename)
      FileUtils.cp tmp.path, file
      @menu.parse(file)
      @menu.save
      FileUtils.rm file
      redirect_to [@store, :items]
    else
      render "new", alert: "Invalid file"
    end
  end
end
