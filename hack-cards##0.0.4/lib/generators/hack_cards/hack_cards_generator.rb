# class HackCardsGenerator < Rails::Generators::NamedBase don't take in a name
# parameter

# railscast 218

class HackCardsGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  argument :layout_name, type: :string, default: "cards"

  # all public methods inside a generator will be executed when you call the
  # generator

  def generate_stylesheets
    copy_file "stylesheet.scss", "app/assets/stylsheets/#{layout_name}.scss"
  end

  def generate_partials
    template "card.html.erb", "app/views/layouts/card.html.erb"
  end
end
