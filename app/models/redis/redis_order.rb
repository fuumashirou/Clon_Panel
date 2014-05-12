class RedisOrder
  @@class_name = "Order"
  attr_accessor :id, :store_id, :checkin_id, :table_number, :ordered_at, :ordered_by, :received, :done

  def initialize options = {}
    self.id           = options[:id]
    self.store_id     = options[:store_id]
    self.checkin_id   = options[:checkin_id]
    self.table_number = options[:table_number]
    self.ordered_at   = options[:ordered_at]
    self.ordered_by   = options[:ordered_by]
    self.received     = options[:received]
    self.done         = options[:done]
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

  def items
    items_ids = $redis.smembers("i:Item:order_id:#{self.id}")
    if items_ids.size > 0
      return RedisItem.find_all items_ids
    else
      return []
    end
  end

  def delete
    $redis.rem("Account:#{id}")
    $redis.srem("i:Account:checkin_id:#{self.checkin_id}", self.id)
    $redis.srem("s:Account", self.id)
    return self
  end

  def save
    hash = {}
    self.instance_variables.each {|var| hash[var.to_s.delete("@")] = self.instance_variable_get(var) }
    hash.each do |key, value|
      unless key == :id
        $redis.hset("#{@@class_name}:#{self.id}", key, value)
      end
    end
    return self
  end

private
  def self.parse_data data
    order = RedisOrder.new({
      id:           data["id"],
      store_id:     data["store_id"],
      checkin_id:   data["checkin_id"],
      table_number: data["table_number"].to_i,
      ordered_at:   DateTime.strptime(data["ordered_at"],'%Q'),
      ordered_by:   data["ordered_by"],
      received:     data["received"] == "true" ? true : false,
      done:         data["done"] == "true" ? true : false
    })
    return order
  end
end
