class ActiveApplication::PublicController < ::ApplicationController
  def not_found
    return render "active_application/public/404", status: :not_found, layout: false
  end
end
