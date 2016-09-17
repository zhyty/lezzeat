class Restaurant < ActiveRecord::Base
  # name, rating, start_hour, end_hour, user_votes

  validates_presence_of :name, :rating, :start_hour, :end_hour
  validates :rating, :numericality

  belongs_to :group
  after_initialize :init

  def self.from_yelp_business(yelp_business)
    self.class.new(name: yelp_business.name, rating: yelp_business.rating, )
  end

  def init
    self.user_votes ||= 0
  end
end