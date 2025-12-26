require 'abbreviated_methods/version'
require 'abbrev'

module AbbreviatedMethods
  def methods_with_their_abbreviations
    public_methods.abbrev.each_with_object({}) do |(key, value), hsh|
      hsh[value] ||= []
      hsh[value] << key unless key == value || key == value.to_s
    end
  end

  def method_missing(method_name, *args)
    if public_methods.abbrev.keys.include?(method_name.to_s)
      send(public_methods.abbrev[method_name.to_s])
    else
      super
    end
  end

  def respond_to?(method_name, *args)
    if public_methods.abbrev.keys.include?(method_name.to_s)
      true
    else
      super
    end
  end

  def respond_to_missing?(method_name, *args)
    if public_methods.abbrev.keys.include?(method_name.to_s)
      true
    else
      super
    end
  end
end
