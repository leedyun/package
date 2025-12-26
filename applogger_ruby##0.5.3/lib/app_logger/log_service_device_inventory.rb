class AppLogger::LogServiceDeviceInventory

  attr_accessor :identifier
  attr_accessor :name
  attr_accessor :hwtype
  attr_accessor :ostype

  def self.discover
    # build the model
    inventory = AppLogger::LogServiceDeviceInventory.new

    # build the inventory
    inventory.identifier =  MacAddr.address.gsub(':','')
    inventory.name       = `hostname`.strip
    inventory.hwtype     = 'MacBookPro10,1'
    inventory.ostype     = 'osx10.9'

    # done
    inventory
  end
end