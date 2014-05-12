class RedisAccount
  @@class_name = "Account"
  # HASH: Account:#{auth_token} Guarda informacion de la cuenta
  # HASH: Store:#{store_id}:User Guarda auth_token "username:auth_token"
  # SET:  i:Account:checkin_id:#{checkin_id} Guarda id de las cuentas en el checkin
  # SET:  s:Account Guarda una lista general de cuentas
  attr_accessor :id, :username, :verified, :checked_at, :checkin_id, :last_order

  def initialize options = {}
    self.id         = options[:id]
    self.username   = options[:username]
    self.verified   = options[:verified]
    self.checked_at = options[:checked_at]
    self.checkin_id = options[:checkin_id]
    self.last_order = options[:last_order]
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

  def delete store_id
    $redis.del("Account:#{self.id}")
    $redis.srem("i:Account:checkin_id:#{self.checkin_id}", self.id)
    $redis.srem("s:Account", self.id)
    $redis.hdel("Store:#{store_id}:User", self.username)
    return true
  end

  def set_checkin checkin_id
    $redis.sadd("i:Account:checkin_id:#{checkin_id}", self.id)
    $redis.hset("Account:#{self.id}", "checkin_id", checkin_id)
    return true
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
    account = RedisAccount.new({
      id:         data["id"],
      username:   data["username"],
      verified:   data["verified"] == "true" ? true : false,
      checked_at: DateTime.strptime(data["checked_at"],'%Q'),
      checkin_id: data["checkin_id"],
      last_order: data["last_order"]
    })
    return account
  end
end
