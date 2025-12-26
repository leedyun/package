require 'active_support'
require 'action_meta_tags/version'
require 'action_meta_tags/helpers'
require 'action_meta_tags/tags/self_closing_tag'
require 'action_meta_tags/tags/link'
require 'action_meta_tags/tags/meta'
require 'action_meta_tags/tags/title'
require 'action_meta_tags/base'

ActiveSupport.on_load(:action_view) do
  include ActionMetaTags::Helpers
end
