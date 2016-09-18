class User < ActiveRecord::Base
  # id, group_code
  belongs_to :group

  # choices should be an array of ids
  def submit_choices(choices)
    Array(choices).each { |id| Restaurant.increment_counter(:user_votes, id) }
    self.destroy
  end
end
