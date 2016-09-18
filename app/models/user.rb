class User < ActiveRecord::Base
  # id, group_code, submitted
  belongs_to :group

  # choices should be an array of ids
  def submit_choices(choices)
    return if self.submitted

    choices.each do |id|
      # FIXME may throw
      Restaurant.increment_counter(:user_votes, id)
    end

    self.submitted = true
  end
end
