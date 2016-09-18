class Restaurant < ActiveRecord::Base
  validates_presence_of :name, :rating, :review_count, :user_votes, :address, :image_url
  validates :rating, numericality: true
  validates :distance, numericality: true, allow_nil: true
  validates :review_count, numericality: {only_integer: true}
  validates :user_votes, numericality: {only_integer: true}

  belongs_to :group
  after_initialize :init

  # parses params from a yelp business object
  def self.params_from_yelp_business(yelp_business, yelp_region_center)
    address = (yelp_business.location.address << yelp_business.location.city).join(', ')

    params = {
        name: yelp_business.name, rating: yelp_business.rating, review_count: yelp_business.review_count,
        address: address, image_url: yelp_business.image_url, is_closed: yelp_business.is_closed
    }

    # sometimes location coordinates aren't provided
    if yelp_business.location.coordinate
      # from yelp_response.region.center
      center_location = Location.new(yelp_region_center.latitude, yelp_region_center.longitude)

      # from yelp_response.businesses[business].location.coordinate
      business_location = Location.new(yelp_business.location.coordinate.latitude, yelp_business.location.coordinate.longitude)
      params[:distance] = Location.distance(center_location, business_location)
    end

    params
  end

  # returns list of params based on yelp response
  def self.params_from_yelp_response(response)
    response.businesses.inject([]) do |result, business|
      result << self.params_from_yelp_business(business, response.region.center)
    end
  end

  def init
    self.user_votes ||= 0
  end
end