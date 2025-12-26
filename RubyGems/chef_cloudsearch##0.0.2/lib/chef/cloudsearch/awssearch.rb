require 'aws-sdk-core'

class Chef
  module Cloudsearch
    module Awssearch
      extend self

      def cloudsearch(account_key, secret_key, region, resource_type, filters)
        search_type = resource_type.downcase
        result = nil
        case search_type
        when :ec2
          conn = return_aws_connection(account_key, secret_key, region, resource_type)
          result = ec2_search(conn, filters)
        end

      end

      def ec2_search(conn, filters)
        results = conn.describe_instances(filters: filters).reservations.first.instances
      end

      def return_aws_connection(account_key, secret_key, region, resource_type)
        type = resource_type.downcase
        Aws.config[:region] = region
        case type
        when :ec2
          return Aws::EC2.new
        when :rds
          return Aws::RDS.new
        else
          # Later
        end
      end
    end

    module DSL
      def cloudsearch(account_key, secret_key, region, resource_type, filters); Chef::Cloudsearch::Awssearch.cloudsearch(account_key, secret_key, region, resource_type, filters); end
    end
  end
end
