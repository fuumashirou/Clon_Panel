class CheckinWorker
  include Sidekiq::Worker

  def perform(store_id)
    Checkin.exists(total: false).each do |checkin|
      total_price = 0
      checkin.billings.each do |billing|
        total_price += billing.paid
      end
      checkin.set(total: total_price)
    end
  end
end
