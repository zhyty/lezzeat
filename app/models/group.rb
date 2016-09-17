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
end
