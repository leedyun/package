require 'dawg'

desc 'create divisions.bin from source'
task :create_divisions do
  subdivisions = []

  IO.foreach('GeoLite2-City-Locations-ru.csv') do |line|
    geoname_id, locale_code, continent_code, continent_name,
    country_iso_code, country_name, subdivision_1_iso_code,
    subdivision_1_name, subdivision_2_iso_code, subdivision_2_name,
    city_name, metro_code, time_zone, is_in_european_union = line.split(',')
    subdivisions << subdivision_1_name.strip.delete('\"')
  end

  subdivisions.uniq!
  subdivisions.sort!
  subdivisions.reject! {|d| d.empty? }
  subdivisions_hash = {}
  subdivisions.each_with_index do |subdivision, index|
    subdivisions_hash[index] = subdivision
  end

  File.open('subdivisions.bin', 'wb') { |f| f.write(Marshal.dump(subdivisions_hash)) }

end


desc 'create dawg file with cities for russia'
task :create_dawg_russia do
  cities = []
  subdivisions = Marshal.load(File.read('subdivisions.bin'))
  subdivisions_inverted = subdivisions.invert

  IO.foreach('GeoLite2-City-Locations-ru.csv') do |line|
    geoname_id, locale_code, continent_code, continent_name,
    country_iso_code, country_name, subdivision_1_iso_code,
    subdivision_1_name, subdivision_2_iso_code, subdivision_2_name,
    city_name, metro_code, time_zone, is_in_european_union = line.split(',')

    next if country_iso_code != 'RU'

    subdivision_1_name = subdivision_1_name.strip.delete('\"')
    city_name = city_name.strip.delete('\"').downcase
    cities << "#{city_name} #{subdivisions_inverted[subdivision_1_name]}"
  end

  cities.uniq!
  cities.sort!
  cities.reject! {|d| d.empty? }

  dawg = Dawg.new
  cities.each do |city|
    dawg.insert(city)
  end

  dawg.finish

  dawg.save('russia.bin')
end

