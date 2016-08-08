class BookingMailer < ApplicationMailer

	def booking_email(booking, listing)
		@customer = booking
		@host = listing
		@user = User.find(@host.user_id)
		@url = "http://localhost:3000/listings"
		mail(to: @user.email, subject: 'A booking has been made for your listing')


	end

end