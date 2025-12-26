# frozen-string-literal: true

require 'commonmarker'

# An extension to CommonMarker that adds plugin support
#
# CommonMarkerPluggable is a shim that adds itself to CommonMarker and
# intercepts calls to `CommonMarker.render_doc`. After a document object is
# created, CommonMarkerPluggable calls the `.call` method of each plugin,
# passing the updated document object each time.
#
# @since 0.2.0
# @see https://github.com/pyrmont/jekyll-commonmarker-pluggable
module CommonMarkerPluggable

  # Collect the plugins
  #
  # @since 0.2.0
  def self.plugins
    @plugins ||= CommonMarker::Plugin.constants.reduce(Array.new) do |total,c|
                   next total unless (m = CommonMarker::Plugin.const_get(c)).is_a? Module
                   total.push m
                 end
  end

  # Render the CommonMark document
  #
  # @since 0.2.0
  def render_doc(text, options = :DEFAULT, extensions = [])
    doc = super(text, options, extensions)
    CommonMarkerPluggable.plugins.each do |plugin|
      plugin.call doc
    end
    doc
  end
end

CommonMarker.singleton_class.prepend CommonMarkerPluggable