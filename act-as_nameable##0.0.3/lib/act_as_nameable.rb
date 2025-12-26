require 'act_as_nameable/version'
require 'act_as_nameable/base'

module ActAsNameable
  def self.root
    require 'pathname'
    Pathname.new(File.expand_path '../..', __FILE__)
  end
end
