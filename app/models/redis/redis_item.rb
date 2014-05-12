class RedisItem
  @@class_name = "Item"
  attr_accessor :id, :item_id, :name, :price, :quantity, :order_id, :ordered_at

  def initialize options = {}
    self.id         = options[:id]
    self.item_id    = options[:item_id]
    self.name       = options[:name]
    self.price      = options[:price]
    self.quantity   = options[:quantity]
    self.order_id   = options[:order_id]
    self.ordered_at = options[:ordered_at]
  end

  def self.find id
    result = $redis.hgetall("#{@@class_name}:#{id}")
    return parse_data result
  end

  def self.find_all array
    objects = []
    array.each do |id|
      result = $redis.hgetall("#{@@class_name}:#{id}")
      if result
        parsed = parse_data result
        objects.push parsed
      end
    end
    return objects
  end

private
  def self.parse_data data
    item = RedisItem.new({
      id:         data["id"],
      item_id:    data["item_id"],
      name:       data["name"],
      price:      data["price"].to_f,
      quantity:   data["quantity"].to_i,
      order_id:   data["order_id"],
      ordered_at: DateTime.strptime(data["ordered_at"],'%Q')
    })
    return item
  end
end
