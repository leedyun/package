module ArchiveUploader
  module Git
    class << self
      def get_timestamp
        `git --no-pager show -s --format='%ai' #{get_commit} | awk '{print $1, $2}' | sed 's/-//g;s/://g;s/ //g'`.strip
      end
      
      def get_author_name
        `git --no-pager show -s --format='%an' #{get_commit}`.strip
      end
      
      def get_author_email
        `git --no-pager show -s --format='%ae' #{get_commit}`.strip
      end
    
      def get_commit
        `git rev-parse HEAD`.strip
      end
    
      def get_branch
        `git rev-parse --abbrev-ref HEAD`.strip
      end
    
      def data
        {
          :commit => get_commit,
          :timestamp => get_timestamp,
          :branch => get_branch,
          :author_name => get_author_name,
          :author_email => get_author_email
        }
      end
    end
  end
end