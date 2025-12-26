# Create a class that is namespaced with the ActiveValidator module and
# is subclassed by ActiveValidator::Base and place it in a directory
# that your application will initialize. In a client based Rails app
# that will not use a database, you can place these into .lib/validatable
#
# module ActiveValidator
#   class SampleValidator < ActiveValidator::Base 

#     # Setup your validators using active_record methods.
#     validates :email, presence: true

#     # Define params that are white-listed. These will be enforced
#     # using Rails safe parameters.
#     safe_params :email, :password
#   end
# end
