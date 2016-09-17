class Group::Code
  def self.check_unique(code)
    Group.find_by(code: code)
  end

  def self.generate_unique_code

  end
end