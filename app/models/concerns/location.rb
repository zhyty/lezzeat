class Location
  attr_reader :lat, :long

  def self.distance(first, second)
      rad_per_deg = Math::PI/180.0  # PI / 180
      earth_radius = 6378.137 * 1000 # metres

      lat_diff_rad = (second.lat-first.lat) * rad_per_deg  # Delta, converted to rad
      lon_diff_rad = (second.long-first.long) * rad_per_deg

      lat1_rad = first.lat * rad_per_deg
      lat2_rad = second.lat * rad_per_deg

      a = Math.sin(lat_diff_rad/2.0)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(lon_diff_rad/2)**2
      c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

      earth_radius * c # Delta in meters
    end

  # in degrees!
  def initialize(latitude, longitude)
    @lat = latitude
    @long = longitude
  end
end