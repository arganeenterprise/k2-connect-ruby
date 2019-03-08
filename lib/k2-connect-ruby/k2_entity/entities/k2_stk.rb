# For STK Push/Receive MPESA Payments from merchant's customers
class K2Stk < K2Entity
  include K2Validation

  # Receive payments from M-PESA users.
  def receive_mpesa_payments(params)
    # Validation
    if validate_input(params, %w{ first_name last_name phone email currency value utf8 authenticity_token decision pay_type commit controller action } )
      # The Request Body Parameters
      k2_request_subscriber = {
          first_name: params["first_name"],
          last_name: params["last_name"],
          phone: params["phone"],
          email: params["email"]
      }
      k2_request_amount = {
          currency: params["currency"],
          value: params["value"]
      }
      k2_request_metadata = {
          customer_id: 123456789,
          reference: 123456,
          notes: "Payment for invoice 12345"
      }
      receive_body = {
          payment_channel: "M-PESA",
          till_identifier: "444555",
          subscriber: k2_request_subscriber,
          amount: k2_request_amount,
          metadata: k2_request_metadata,
          call_back_url: "https://call_back_to_your_app.your_application.com"
      }
      receive_hash = K2Stk.make_hash("payment_requests", "POST", @access_token, "STK", receive_body)
      @threads << Thread.new do
        sleep 0.25
        K2Connect.to_connect(receive_hash)
      end
      @threads.each {|t| t.join}
    end
  end

  # Query/Check STK Payment Request Status
  def query_status(params, path_url = "payment_requests", class_type = "STK")
    super
  end
end