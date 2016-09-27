module GroupsHelper
  # expected that distance is given in metres!
  def display_distance(dist)
    if dist.nil?
      'Unknown'
    elsif dist > 1000
      "#{(dist/1000.0).round(2)} km"
    elsif dist > 100
      "#{dist.round(-2)} m"
    elsif dist > 0
      '<100 m'
    end
  end

  def display_review_count(count)
    count == 1 ? "#{count} review" : "#{count} reviews"
  end
end
