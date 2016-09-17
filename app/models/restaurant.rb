class Restaurant < ActiveRecord::Base
  # name, rating, start_hour, end_hour, user_votes

  validates_presence_of :name, :rating, :start_hour, :end_hour

  belongs_to :group
  after_initialize :init

  def init
    self.user_votes ||= 0
  end
end