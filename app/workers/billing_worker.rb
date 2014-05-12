class BillingWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { monthly.day_of_month(5) }

  def perform
    today = Time.current.day
    logger.info { "perform schedule day #{today}" }
    stores = Store.where(verified: true)
    stores.each do |store|
      unless store.payment_methods.empty?
        GenerateBilling.perform_async(store._id.to_s)
        logger.info { "processing #{store.name}" }
      end
    end
  end

end
