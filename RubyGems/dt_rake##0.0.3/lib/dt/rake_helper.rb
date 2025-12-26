module Dt
  module RakeHelper

    @role_tag = nil

    class << self
      attr_accessor :role_tag
    end

    def self.role_tag_clear
      @role_tag = nil
    end  

    def tag(role_tag)
      Dt::RakeHelper.role_tag = role_tag
    end  

    def role(*roles, &blk)
      roles << 'all'
      matching_role = server_roles.detect { |r| roles.include? r}
      if matching_role
        yield 
      else
        tag = Dt::RakeHelper.role_tag
        puts "Skipping #{tag}" if tag
      end
    ensure
      Dt::RakeHelper.role_tag_clear  
    end  

    def rake_invoke(task)
      Rake::Task[task].invoke
    end

    def server_roles
      return @server_roles if @server_roles
      if ENV['SERVER_ROLES'] =~ /^[a-z0-9A-Z][a-z0-9A-Z,_]*$/
        @server_roles = ENV['SERVER_ROLES'].split(',')
      else
        @server_roles = []
      end
      return @server_roles  
    end 

  end
end  
