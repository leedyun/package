class Article < ActiveRecord::Base
    attr_accessible :title,:published
    acts_as_publicable
end

class Post < ActiveRecord::Base
end
