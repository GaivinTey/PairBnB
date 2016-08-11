class DeleteBookingJob < ActiveJob::Base
  queue_as :default

  def perform(booking)
    # Do something later
    if Payment.find_by(booking_id: booking.id) == nil
    	booking.destroy 
    	date_range = booking.startdate..booking.enddate.to_a
    	date_range.each do |date|
    		AvailableDate.find_by(listing_id: booking.listing_id, date:date).destroy
    	end
    end
  end

end
