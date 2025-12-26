require 'dawg'

class CitySearch
  def search(q)
    results = db.query(q.downcase).reject {|r| r.empty? }
    results.map do |r|
      result = r.split(' ')
      code = result.last
      result.pop

      city_name = result.join(' ')
                        .split
                        .map(&:capitalize)
                        .join(' ')
      state = states[code.to_i]

      [city_name, state]
    end
  end

  def db
    @all ||= Dawg.load(File.join(data_path, 'russia.bin'))
  end

  def states
    @states ||= Marshal.load(
      File.read(File.join(data_path, 'subdivisions.bin'))
    )
  end

  private

  def data_path
    @data_path ||= File.join(File.dirname(__FILE__), '/../data')
  end
end
