class ListingsController < ApplicationController
	before_action :find_listing, only: [:show, :edit, :update, :destroy]

	def index
		@listings = Listing.all
	end


	def show
	end

	def new
		@listing = Listing.new
	end

	def create
		@listing = current_user.listings.create(listing_params)
	end

	def edit
	end

	def update
    respond_to do |format|
     if @listing.update(listing_params)
  		format.html { redirect_to @listing, notice: 'Listing was successfully updated.' }
     else
      format.html { render :edit }
      end
       end
    end

	def destroy
	end

	def find_listing
		@listing = Listing.find(params[:id])
	end

	def listing_params
		params.require(:listing).permit(:title, :address, :price)
	end


end
