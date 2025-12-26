require 'dragonfly'
require "dragonfly/cloudinary_datastore"

Dragonfly::App.register_datastore(:cloudinary) { Dragonfly::CloudinaryDatastore }

