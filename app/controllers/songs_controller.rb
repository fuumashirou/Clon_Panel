class SongsController < ApplicationController
  before_filter :set_store
  before_action :set_song, only: [:show, :edit, :update, :destroy]

  def index
    @songs = @store.songs
  end

  def show
  end

  def new
    @song = @store.songs.build
  end

  def edit
  end

  def create
    @song = @store.songs.new(song_params)

    if @song.save
      redirect_to [@store, :songs], notice: 'Song was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @song.update(song_params)
      redirect_to [@store, :songs], notice: 'Song was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @song.destroy
    redirect_to [@store, :songs], notice: 'Song was successfully destroyed.'
  end

private
  def set_song
    @song = @store.songs.find(params[:id])
  end
  def song_params
    params.require(:song).permit(:artist, :title, :category)
  end
end
