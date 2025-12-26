require "first_giving_api/version"
require "first_giving_api/charity"
require "first_giving_api/configuration"

module FirstGivingApi
  extend Configuration

  #default lookup method
  def self.lookup(charity_name)
    Charity.new.query_contains(charity_name)
  end
  #lookup returns set that starts with search term
  def self.lookup_starting_with(charity_name)
    Charity.new.query_starts_with(charity_name)
  end
  #lookup using UUID
  def self.lookup_id(charity_uuid)
    Charity.new.query_uuid(charity_uuid)
  end
end