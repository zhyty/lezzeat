module Group::Code
  LENGTH = 4

  module_function

  def self.exist?(code)
    !!Group.find_by_code(code)
  end

  def self.generate_unique_code
    loop do
      possible_code = ('a'..'z').to_a.shuffle[0, LENGTH].join
      return possible_code unless exist?(possible_code)
    end
  end
end