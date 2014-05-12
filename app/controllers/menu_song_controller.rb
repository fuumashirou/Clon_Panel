class MenuSongController < ApplicationController
   before_action :set_store
  before_action :primary_only


  def new
  	@menu_song = Songs.new(store: @store._id)
  end

  def create
  	if params[:file].original_filename.split(".")[-1] == "xlsx"
      @menu = Songs.new(store: @store._id)
      tmp = params[:file].tempfile
      file = File.join("public", params[:file].original_filename)
      FileUtils.cp tmp.path, file
      @menu_song.parse(file)
      @menu_song.save
      FileUtils.rm file
      redirect_to [@store, :songs]
    else
      render "new", alert: "Invalid file"
    end
  end
end
