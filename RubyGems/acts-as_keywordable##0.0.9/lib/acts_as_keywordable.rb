require "acts_as_keywordable/version"
require "acts_as_keywordable/keyword"
require "acts_as_keywordable/keywording"

module ActiveRecord
  module Acts #:nodoc:
    module Keywordable #:nodoc:
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def acts_as_keywordable(options = {})
          class_attribute(:acts_as_keywordable_options, {
            :keywordable_type => self.base_class.name.to_s,
            :from => options[:from]
          })


          has_many :keywordings, :as => :keywordable, :dependent => :destroy
          has_many :keywords, :through => :keywordings

          include ActiveRecord::Acts::Keywordable::InstanceMethods
          extend ActiveRecord::Acts::Keywordable::SingletonMethods
        end
      end

      module SingletonMethods
        def find_tagged_with(list)
          sql_str = %Q(
            SELECT #{table_name}.* FROM #{table_name}, keywords, keywordings
            WHERE #{table_name}.#{primary_key} = taggings.keywordable_id
            AND keywordings.keywordable_type = ?
            AND keywordings.keyword_id = keywords.id AND keywords.name IN (?)

          )
          find_by_sql([sql_str, acts_as_taggable_options[:keywordable_type], list])
        end

        def tags_count(options)
          sql = "SELECT  keywords.id AS id, keywords.name AS name, COUNT(*) AS count FROM keywords, keywordings, #{table_name} "
          sql << "WHERE keywordings.keywordable_id = #{table_name}.#{primary_key} AND keywordings.keyword_id = keywords.id "
          sql << "AND #{sanitize_sql(options[:conditions])} " if options[:conditions]
          sql << "GROUP BY keywords.name "
          sql << "HAVING count #{options[:count]} " if options[:count]
          sql << "ORDER BY #{options[:order]} " if options[:order]
          sql << "LIMIT #{options[:limit]} " if options[:limit]
          find_by_sql(sql)
        end
      end

      module InstanceMethods
        def tag_with(list)
          Keyword.transaction do
            keywordings.destroy_all

            Keyword.parse(list).each do |name|
              if acts_as_keywordable_options[:from]
                send(acts_as_keywordable_options[:from]).keywords.find_or_create_by_name(name).on(self)
              else
                Keyword.find_or_create_by_name(name).on(self)
              end
            end
          end
        end

        def add_keywords(list)
          Keyword.transaction do
            keywordings.destroy_all

            Keyword.parse(list).each do |name|
              if acts_as_keywordable_options[:from]
                send(acts_as_keywordable_options[:from]).keywords.find_or_create_by_name(name).on(self)
              else
                Keyword.find_or_create_by_name(name).on(self)
              end
            end
          end
        end

        def tag_list
          #keywords.collect { |tag| righttag.name.include?(" ") ? "'#{tag.name}'" : tag.name }.join(" ")
        end

      end
    end
  end
end


ActiveRecord::Base.send(:include, ActiveRecord::Acts::Keywordable)