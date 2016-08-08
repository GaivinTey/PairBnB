class BookingsController < ApplicationController

  def index
    @bookings = current_user.bookings.all
  end    

  def new
    @booking = Booking.new
    set_listing
  end

  def create
	  if signed_in? and current_user
     set_listing
     @booking = current_user.bookings.new(booking_params)
     @booking.listing = @listing
      respond_to do |format|
	      if @booking.save
	      	BookingMailer.booking_email(@booking, @listing).deliver
          reserve_dates(@booking.startdate, @booking.enddate, @listing.id)
          format.html { redirect_to bookings_path, notice: 'Booking was successfully created.' }
        else
          @errors = @booking.errors.full_messages
        	format.html { redirect_to listings_path }
        end
      end
	  else
      redirect_to '/sign_in', notice: 'You are not logged in' 
	  end    
  end

  def show
    set_listing
    @booking = Booking.find(params[:id])
  end

  def edit
    set_listing
    @booking = Booking.find(params[:id])
  end

  private

  def booking_params
   processed_params = params.require(:booking).permit(:startdate, :enddate, :guest, :listing_id)
   processed_params[:startdate] = Date.strptime(processed_params[:startdate], "%m-%d-%Y")
   processed_params[:enddate] = Date.strptime(processed_params[:enddate], "%m-%d-%Y")
   return processed_params
  end

  def set_listing
     @listing = Listing.find(params[:listing_id])
 	end

 def reserve_dates(startdate, enddate, listing_id)
   dates_booked = (startdate..enddate).to_a
   dates_booked.each do |date|
     available_date = AvailableDate.new
     available_date.date = date
     available_date.availability = false
     available_date.listing_id = listing_id
     available_date.save
     end    
 end

end