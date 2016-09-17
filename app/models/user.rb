class User < ActiveRecord::Base
  # id, group_code, submitted
  belongs_to :group
  def submitted?
    @submitted
  end
end
