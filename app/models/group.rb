class Group < ActiveRecord::Base
  # users, id, restaurants, code, location, radius
  # need to call destroy in order to get rid of users and restaurants (delete won't cut it)
  has_many :users, :dependent => :destroy
  has_many :restaurants, :dependent => :destroy

  validates_presence_of :location, :radius
  validates :radius, numericality: {only_integer: true}

  after_initialize :init

  # returns id added or false if group doesn't exist
  def self.add_user_by_code(group_code)
    group = Group.find_by_code(group_code)
    return (group) ? group.users.create.id : false
  end

  def init
    self.code ||= Code::generate_unique_code
  end

  def retrieve_restaurants
    # only load restaurants once
    return true unless restaurants.empty?

    response_1_to_20 = Yelp.client.search(self.location, term: 'restaurants', radius_filter: self.radius * 1000)
    response_21_to_40 = Yelp.client.search(self.location, term: 'restaurants', offset: 20, radius_filter: self.radius * 1000)

    self.restaurants.create(Restaurant.params_from_yelp_response(response_1_to_20) + Restaurant.params_from_yelp_response(response_21_to_40))
    return true
  rescue Yelp::Error::UnavailableForLocation
    Rails.logger.debug "Unable to retrieve restaurants for #{self.location}"
    return false
  rescue Yelp::Error::AreaTooLarge
    Rails.logger.debug "Radius too large: #{self.radius}"
    return false
  end
end
