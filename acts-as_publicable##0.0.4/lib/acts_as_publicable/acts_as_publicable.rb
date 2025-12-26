module ActsAsPublicable

    class FieldNotPresentError < StandardError; end
    module ActiveRecordExtension

        extend ActiveSupport::Concern

        module ClassMethods
            def acts_as_publicable
                raise ActsAsPublicable::FieldNotPresentError unless column_names.include?(:published.to_s)
                scope :by_published_state, lambda { |state| where("published = ?",state) }
                scope :published, by_published_state(true)
                scope :unpublished, by_published_state(false)
            end
        end

        module InstanceMethods

            def publish!
                self.published = true
                save!
            end

            def unpublish!
                self.published = false
                save!
            end

        end

    end
end
