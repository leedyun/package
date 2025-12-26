class ActiveApplication::UserResourceController < SimpleResource::UserResourceController
  defaults route_prefix: ""
  before_filter :exclude_fields
  has_scope :page, default: 1

  def exclude_fields
    @exclude_fields = %w(user_id)
  end
end
