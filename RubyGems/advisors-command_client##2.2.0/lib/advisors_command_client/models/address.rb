module AdvisorsCommandClient
  module Models
    class Address < Base
      attribute :id, Integer
      attribute :primary, Boolean
      attribute :street, String
      attribute :street2, String
      attribute :city, String
      attribute :postal_code, String
      attribute :created_at, DateTime
      attribute :updated_at, DateTime
      attribute :country, String
      attribute :region, String
      attribute :types, Array[String]

      def region
        state_map.key(@region) || @region
      end

      def region_code
        state_map[@region] || @region
      end

      def full_address
        [street, street2, city, region, postal_code, country].compact.join(' ')
      end

      def ==(other_address)
        full_address.downcase == other_address.full_address.downcase
      end

      def as_json
        json_attrs = attributes.dup
        json_attrs.delete(:id)
        json_attrs.delete(:types)
        json_attrs.delete(:created_at)
        json_attrs.delete(:updated_at)
        json_attrs.to_camelback_keys
      end

      private

      def state_map
        {
          "Alabama" => "AL",
          "Alaska" => "AK",
          "Arizona" => "AZ",
          "Arkansas" => "AR",
          "California" => "CA",
          "Colorado" => "CO",
          "Connecticut" => "CT",
          "Delaware" => "DE",
          "District of Columbia" => "DC",
          "Florida" => "FL",
          "Georgia" => "GA",
          "Hawaii" => "HI",
          "Idaho" => "ID",
          "Illinois" => "IL",
          "Indiana" => "IN",
          "Iowa" => "IA",
          "Kansas" => "KS",
          "Kentucky" => "KY",
          "Louisiana" => "LA",
          "Maine" => "ME",
          "Maryland" => "MD",
          "Massachusetts" => "MA",
          "Michigan" => "MI",
          "Minnesota" => "MN",
          "Mississippi" => "MS",
          "Missouri" => "MO",
          "Montana" => "MT",
          "Nebraska" => "NE",
          "Nevada" => "NV",
          "New Hampshire" => "NH",
          "New Jersey" => "NJ",
          "New Mexico" => "NM",
          "New York" => "NY",
          "North Carolina" => "NC",
          "North Dakota" => "ND",
          "Ohio" => "OH",
          "Oklahoma" => "OK",
          "Oregon" => "OR",
          "Pennsylvania" => "PA",
          "Rhode Island" => "RI",
          "South Carolina" => "SC",
          "South Dakota" => "SD",
          "Tennessee" => "TN",
          "Texas" => "TX",
          "Utah" => "UT",
          "Vermont" => "VT",
          "Virginia" => "VA",
          "Washington" => "WA",
          "West Virginia" => "WV",
          "Wisconsin" => "WI",
          "Wyoming" => "WY"
        }
      end
    end
  end
end