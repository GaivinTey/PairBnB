class PaymentsController < ApplicationController

	def new
		@amount = calculate_amount
		@payment = Payment.new
		gon.client_token = generate_client_token

	end

	def create

		  @result = Braintree::Transaction.sale(
              amount: calculate_amount,
              payment_method_nonce: params[:payment_method_nonce])
    if @result.success?
    	BookingMailerJob.perform_later(@booking, @listing)
      current_user.payments.create(booking_id: params[:booking_id], amount: calculate_amount, paid: true, transaction_id: @result.transaction.id)
      redirect_to root_url, notice: "Congraulations! Your transaction has been made successfully!"
      
    else

      flash[:alert] = "Something went wrong while processing your transaction. Please try again!"
      gon.client_token = generate_client_token
      render :new
    end
	end




	private
	def calculate_amount
		@booking = Booking.find(params[:booking_id])
		@listing = @booking.listing
		duration = (@booking.startdate..@booking.enddate).to_a.count
		total_price = duration * @listing.price
	end

	def generate_client_token
  	Braintree::ClientToken.generate
	end




end
