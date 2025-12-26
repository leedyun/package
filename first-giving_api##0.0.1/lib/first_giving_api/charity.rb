require 'curb'
require 'nokogiri'
require 'crack'

module FirstGivingApi
  class Charity
    BASE_URL = 'http://graphapi.firstgiving.com/v1/list/organization?'
    UUID_QUERY_URL = 'http://graphapi.firstgiving.com/v1/object/organization/'
    
    def initialize
    end

    def query_starts_with(charity_name)
      http = Curl.get(BASE_URL+"q=organization_name:#{charity_name}*")
      response = Crack::XML.parse(http.body_str)
      result = response["payload"]["payload"].to_a
      result.each do |subset|
        subset.shift
      end
      result
    end
    def query_contains(charity_name)
      http = Curl.get(BASE_URL+"q=organization_name:#{charity_name}")
      response = Crack::XML.parse(http.body_str)
      result = response["payload"]["payload"].to_a
      result.each do |subset|
        subset.shift
      end
      result
    end
    def query_uuid(charity_uuid)
      http = Curl.get(UUID_QUERY_URL+charity_uuid)
      response = Crack::XML.parse(http.body_str)
      result = response["payload"]["payload"]
    end
  end

  class ApiResponse
    # attr_reader :organization_uuid,
    #             :organization_type_id,
    #             :government_id,
    #             :parent_organization_uuid,
    #             :address_line_1,
    #             :address_line_2,
    #             :address_line_3,
    #             :address_line_full,
    #             :city,
    #             :region,
    #             :postal_code,
    #             :county,
    #             :country,
    #             :address_full,
    #             :phone_number,
    #             :area_code,
    #             :url,
    #             :category_code,
    #             :latitude,
    #             :longitude,
    #             :revoked

    def initialize(result)
      # xml = Crack::XML.parse(result) 
      # @organization_uuid = xml.at('OrganizationUuid').text
      # @organization_type_id = xml.at('OgranizationTypeId').text
      # @government_id = xml.at('GovernmentId').text
      # @parent_organization_uuid = xml.at('ParentOrganizationUuid').text
      # @address_line_1 = xml.at('AddressLine1').text
      # @address_line_2 = xml.at('AddressLine2').text
      # @address_line_3 = xml.at('AddressLine3').text
      # @address_line_full = xml.at('AddressLineFull').text
      # @city = xml.at('City').text
      # @region = xml.at('Region').text
      # @postal_code = xml.at('PostalCode').text
      # @county = xml.at('County').text
      # @country = xml.at('Country').text
      # @address_full = xml.at('AddressFull').text
      # @phone_number = xml.at('PhoneNumber').text
      # @area_code = xml.at('AreaCode').text
      # @url = xml.at('Url').text
      # @category_code = xml.at('CategoryCode').text
      # @latitude = xml.at('Latitude').text
      # @longitude = xml.at('Longitude').text
      # @revoked = xml.at('Revoked')
    end
  end
end
