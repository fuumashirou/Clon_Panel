class RedisCheckin
  @@class_name = "Checkin"
  # HASH: Checkin:#{checkin_id} Guarda informacion del checkin
  # SET:  i:Checkin:table_id:#{table_id} Guarda id del checkin en la mesa
  # SET:  i:Checkin:store_id:#{store_id} Guarda id del checkin en el local
  # SET:  s:Checkin Guarda una lista general de checkins
  attr_accessor :id, :table_id, :table_number, :store_id, :arrive_at, :leave_at, :users, :bills, :moved_to

  def initialize options = {}
    self.id           = options[:id]
    self.table_id     = options[:table_id]
    self.table_number = options[:table_number]
    self.store_id     = options[:store_id]
    self.arrive_at    = options[:arrive_at]
    self.leave_at     = options[:leave_at]
    self.users        = options[:users]
    self.bills        = options[:bills]
    self.moved_to     = options[:moved_to]
  end

  def self.find id
    result = $redis.hgetall("#{@@class_name}:#{id}")
    return result ? parse_data(result) : nil
  end

  def self.find_by object
    if object[:table_number]
      array = $redis.smembers("i:Checkin:table_number:#{object[:table_number]}")
    elsif object[:table_id]
      array = $redis.smembers("i:Checkin:table_id:#{object[:table_id]}")
    elsif object[:store_id]
      array = $redis.smembers("i:Checkin:store_id:#{object[:store_id]}")
    end
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

  def save
    hash = {}
    self.instance_variables.each {|var| hash[var.to_s.delete("@")] = self.instance_variable_get(var) }
    hash.each do |key, value|
      unless key == :id
        value = value.nil? ? "" : value
        $redis.hset("#{@@class_name}:#{self.id}", key, value)
      end
    end
    return self
  end


  def bills
    return $redis.smembers("i:Bill:checkin_id:#{self.id}")
  end

  def orders
    orders_ids = $redis.smembers("i:Order:checkin_id:#{self.id}")
    if orders_ids.size > 0
      return RedisOrder.find_all orders_ids
    else
      return []
    end
  end

  def accounts
    account_ids = $redis.smembers("i:Account:checkin_id:#{self.id}")
    if account_ids.size > 0
      return RedisAccount.find_all account_ids
    else
      return []
    end
  end

  def change_table table_id
    # Ver si pidio cuenta
    if self.bills.size == 0
      store = Store.find(self.store_id)
      new_table = store.tables.find(table_id)
      # Ver si nueva mesa tiene checkins
      if RedisCheckin.find_by({ table_id: table_id }).size == 0
        # Cambiar ordenes de mesa
        self.orders.each do |order|
          # Crear up "update_attribute"
          order.table_number = new_table.number
          order.save
        end
        # Change table
        self.set_table new_table
        return true
      else
        # Ya existe un checkin
        return false
      end
    else
      # Necesita pagar la cuenta
      return false
    end
  end

  def merge_table table_id
    # Ver si pidio cuenta
    if self.bills.size == 0
      store = Store.find(self.store_id)
      new_table = store.tables.find(table_id)
      # Ver si nueva mesa tiene checkins
      new_checkin = RedisCheckin.find_by({ table_id: table_id }).first
      if new_checkin
        # Cambiar ordenes de mesa
        self.orders.each do |order|
          # Crear up "update_attribute"
          order.table_number = new_table.number
          order.save
        end
        # Checkout y cambiar checkin_id de las cuentas
        self.checkout new_checkin.id
        return true
      else
        # No existe un checkin
        return false
      end
    else
      # Necesita pagar la cuenta
      return false
    end
  end

  def checkout new_checkin_id = nil
    $redis.hset("Checkin:#{self.id}", "leave_at", Time.current.utc.to_i)
    if new_checkin_id
      $redis.hset("Checkin:#{self.id}", "moved_to", new_checkin_id)
    end
    accounts = self.accounts
    # Remover datos
    $redis.srem("i:Checkin:table_id:#{self.table_id}", self.id)
    $redis.srem("i:Checkin:store_id:#{self.store_id}", self.id)
    $redis.srem("s:Checkin", self.id)
    $redis.del("i:Account:checkin_id:#{self.id}")
    # Remover usuarios
    users = self.users
    accounts.each do |account|
      unless new_checkin_id.nil?
        account.set_checkin new_checkin_id
        users.push(account.username) unless self.users.include? account
      else
        account.delete self.store_id
      end
    end
    self.update_users(users) if new_checkin_id
    # self.save if new_checkin_id # Guardar para añadir usuarios a la lista
    return true
  end

  def update_users users
    $redis.hset("Checkin:#{self.id}", "users", users.join(","))
  end

  def set_table table
    # Cambiar indice
    $redis.sadd("i:Checkin:table_id:#{table._id}", self.id)
    $redis.srem(%Q[i:Checkin:table_id:#{self.table_id}], self.id)
    # Cambiar checkin
    $redis.hset("Checkin:#{self.id}", "table_id", table._id)
    $redis.hset("Checkin:#{self.id}", "table_number", table.number)
    return true
  end

  def self.parse_data data
    checkin = RedisCheckin.new({
      id:           data["id"],
      table_id:     data["table_id"],
      table_number: data["table_number"].to_i,
      store_id:     data["store_id"],
      arrive_at:    DateTime.strptime(data["arrive_at"],'%Q'),
      leave_at:     data["leave_at"].nil? ? nil : DateTime.strptime(data["leave_at"],'%Q'),
      users:        data["users"].split(","),
      bills:        data["bills"].to_i,
      moved_to:     data["moved_to"]
    })
    return checkin
  end
end
