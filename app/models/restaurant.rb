class Restaurant < ActiveRecord::Base
  # name, rating, start_hour, end_hour, user_votes

  validates_presence_of :name, :rating, :review_count, :user_votes, :distance, :address, :image_url, :is_closed
  validates :rating, numericality: true
  validates :distance, numericality: true
  validates :review_count, numericality: {only_integer: true}
  validates :user_votes, numericality: {only_integer: true}

  belongs_to :group
  after_initialize :init

  def self.from_yelp_business(yelp_business, yelp_region_center)
    # from yelp_response.region.center
    center_location = Location.new(yelp_region_center.latitude, yelp_region_center.longitude)

    # from yelp_response.businesses[business].location.coordinate
    business_location = Location.new(yelp_business.location.coordinate.latitude, yelp_business.location.coordinate.longitude)

    self.new(
        name: yelp_business.name, rating: yelp_business.rating, review_count: yelp_business.review_count,
        distance: Location.distance(center_location, business_location), address: yelp_business.location.address.join(', '),
        image_url: yelp_business.image_url, is_closed: yelp_business.is_closed
    )
  end

  def self.from_yelp_response(response)
    response.businesses.inject([]) do |result, business|
      result << self.from_yelp_business(business, response.region.center)
    end
  end

  def init
    self.user_votes ||= 0
  end
end