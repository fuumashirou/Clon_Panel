class Menu

  def initialize(*args)
    @sheets = %w(items)
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

    @hash["items"].each do |item|
      item = store.items.create(name: item["name"], description: item["description"], price: item["price"].to_f, type: item["type"], category: item["category"])
    end
  end

private
  def parse_sheet(elements, header)
    array = []
    elements.drop(1).each do |row|
      hash = {}
      row.each_with_index do |item, index|
        hash[header[index].downcase] = row[index]
      end
      array.push(hash)
    end
    return array
  end

end
