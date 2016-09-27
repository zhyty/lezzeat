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

    # TODO move this to params_from_yelp_response?
    response = Yelp.client.search(self.location, term: 'restaurants', radius_filter: self.radius * 1000, limit: 15)

    self.restaurants.create(Restaurant.params_from_yelp_response(response))
    return true
  rescue Yelp::Error::UnavailableForLocation
    Rails.logger.debug "Unable to retrieve restaurants for #{self.location}"
    return false
  rescue Yelp::Error::AreaTooLarge
    Rails.logger.debug "Radius too large: #{self.radius}"
    return false
  end
end
