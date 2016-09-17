class Group < ActiveRecord::Base
  # users, id, restaurants
  has_many :users
  has_many :restaurants
  after_initialize :init

  validates_presence_of :location, :radius
  validates :radius, numericality: {only_integer: true}

  def init
    self.code ||= Code::generate_unique_code
  end

  def user_count
    # TODO
  end

  def retrieve_restaurants
    self.restaurants.clear
    response_1_to_20 = Yelp.client.search(self.location, term: 'restaurants', radius_filter: self.radius)
    response_21_to_40 = Yelp.client.search(self.location, term: 'restaurants', offset: 20, radius_filter: self.radius)
    self.restaurants.create(Restaurant.params_from_yelp_response(response_1_to_20) + Restaurant.params_from_yelp_response(response_21_to_40))

    # TODO error checking
  end
end
