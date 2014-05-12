class Songs

  def initialize(*args)
    @sheets = %w(songs)
    @store = args[0][:store]
  end

  def parse(file)
    file = Roo::Excelx.new(file)

    @hash = {}
    file.each_with_pagename do |name, sheet|
      name = name.downcase
      if @sheets.include?(name)
        array = parse_sheet(sheet, sheet.row(sheet.first_row))
        @hash[name] = array
      end
    end
    return @hash
  end

  def save
    store = Store.find(@store)

    @hash["songs"].each do |song|
      song = store.songs.create(artist: song["artist"], title: song["title"], category: song["category"])
    end
  end

private
  def parse_sheet(elements, header)
    array = []
    elements.drop(1).each do |row|
      hash = {}
      row.each_with_index do |song, index|
        hash[header[index].downcase] = row[index]
      end
      array.push(hash)
    end
    return array
  end

end
