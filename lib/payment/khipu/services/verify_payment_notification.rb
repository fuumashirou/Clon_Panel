module Khipu
  class VerifyPaymentNotification

    def self.local_security_validation data
      params = {
        api_version:     data.api_version,
        receiver_id:     data.receiver_id,
        notification_id: data.notification_id,
        subject:         data.subject,
        amount:          data.amount,
        currency:        data.currency,
        transaction_id:  data.transaction_id,
        payer_email:     data.payer_email,
        custom:          data.custom
      }
      notification_signature = data.notification_signature
      local_validation(params, notification_signature)
    end

    def local_validation params, notification_signature
      receiver   = Khipu::Receiver.default
      string     = params.map{ |key, value| "#{key}=#{value}" }.join("&")
      signature  = Base64.decode64 notification_signature
      public_key = receiver.load_cert

      valid_certificate = public_key.verify(digest, signature, public_key)

      if valid_certificate && params[:receiver_id] == receiver.id
        return params[:transaction_id]
      else
        return false
      end
    end

  end
end
