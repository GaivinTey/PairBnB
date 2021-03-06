class Listing < ActiveRecord::Base
	belongs_to :user
	has_many :listing_tags
	has_many :tag, through: :listing_tags
  has_many :bookings
  has_many :available_dates

    searchkick

    mount_uploaders :avatars, AvatarUploader

	filterrific(
    default_filter_params: { search_query: '' },
    available_filters: [
      :search_query,
      :sorted_by
    ]
  )

scope :search_query, lambda { |query|
  return nil  if query.blank?

  terms = query.downcase.split(/\s+/)

  terms = terms.map { |e|
    (e.gsub('*', '%') + '%').gsub(/%+/, '%')
  }

  num_or_conds = 2
  where(
    terms.map { |term|
      "(LOWER(listings.title) LIKE ? OR LOWER(listings.address) LIKE ?)"
    }.join(' AND '),
    *terms.map { |e| [e] * num_or_conds }.flatten
  )
}

	scope :sorted_by, lambda { |sort_option|
  direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
  case sort_option.to_s
  when /^price/
    order("listings.price #{ direction}")
  else
    raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
  end
}
	




		def self.options_for_sorted_by
    [
      ['Price (High-Low)', 'price_desc'],
      ['Price (Low-High)', 'price_asc'],
      
    ]
  end

  def search_data
    {
      title: title,
      address: address,
      price: price
    }
  end


end
