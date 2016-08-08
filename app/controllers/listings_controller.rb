class ListingsController < ApplicationController
	before_action :find_listing, only: [:show, :edit, :update, :destroy]


		def index
		@filterrific = initialize_filterrific(
      Listing,
      params[:filterrific],
      select_options: {
      	sorted_by: Listing.options_for_sorted_by
      }
    ) or return

    @listings = @filterrific.find
    
    respond_to do |format|
      format.html
      format.js
    end
	
	end


	def show
	end

	def new
		@listing = Listing.new
	end

	def create
		@listing = current_user.listings.create(listing_params)
		redirect_to listings_path
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
    @listing.destroy
    respond_to do |format|
    format.html { redirect_to listings_url, notice: 'listing was successfully destroyed.' }
    end
  end

	def find_listing
		@listing = Listing.find(params[:id])
	end

	def listing_params
		params.require(:listing).permit(:title, :address, :price, tag_ids: [], avatars: [])
	end


end
