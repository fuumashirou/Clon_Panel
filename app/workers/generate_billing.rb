class GenerateBilling
  include Sidekiq::Worker

  def perform(store_id)
    # Set Date and time
    this_month = Time.current.utc
    prev_month = Chronic.parse("one month before now").utc
    store = Store.find(store_id)
    time  = this_month.strftime("%X")
    # Set default variables
    total  = 0
    orders = store.orders.where(ordered_at: {'$gte' => prev_month.beginning_of_month,'$lt' => prev_month.end_of_month})
    unless orders.empty?
      orders.each do |order|
        if order.total
          total += order.total
        else
          order.items.each do |item|
            total += item["price"].to_f*item["quantity"].to_i
          end
        end
      end
      id = Moped::BSON::ObjectId.new
      to_pay  = total*(store.payment/100)
      billing = store.billings.new(_id: id, gross_value: total, net_value: to_pay, payment: store.payment, from_date: prev_month.beginning_of_month, to_date: prev_month.end_of_month, time: time)
      logger.info { "#{orders.count} orders, payment: #{to_pay}" }
      # Khipu logic
      payment_method = store.payment_methods.where(default: true).first
      if to_pay <= 200
        if payment_method.method == "khipu"
          subject = "Cobro mensual Twable."
          body    = "Puedes ver el detalle de tu cobro en http://panel.twable.com ingresando con tu usuario y contraseña en la sección de cobros."
          payment = Khipu::CreatePaymentUrl.new({
            subject:        subject,
            body:           body,
            amount:         to_pay,
            payer_email:    payment_method.email,
            transaction_id: id.to_s
          })
          billing.url = payment.url
          billing.mobile_url = payment.mobile_url
        end
        # Save billing
        billing.method = payment_method.method
        billing.save
      else
        store.billings.create(payment: store.payment, from_date: prev_month.beginning_of_month, to_date: prev_month.end_of_month, time: time, paid_at: time, paid: true)
        logger.info { "Payment less than 200" }
      end
    else
      store.billings.create(payment: store.payment, from_date: prev_month.beginning_of_month, to_date: prev_month.end_of_month, time: time, paid_at: time, paid: true)
      logger.info { "No orders" }
    end
  end

end
