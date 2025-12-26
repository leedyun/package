# frozen_string_literal: true

module GitlabQuality
  module TestTooling
    module Report
      module Concerns
        module GroupAndCategoryLabels
          def labels_inference
            @labels_inference ||= GitlabQuality::TestTooling::LabelsInference.new
          end

          def new_issue_labels(test)
            debug_line = '  => [DEBUG] '
            debug_line += "product_group: #{test&.product_group}; " if test.respond_to?(:product_group)
            debug_line += "feature_category: #{test&.feature_category}" if test.respond_to?(:feature_category)
            puts debug_line

            new_labels = self.class::NEW_ISSUE_LABELS
            new_labels += labels_inference.infer_labels_from_product_group(test.product_group) if test.respond_to?(:product_group)
            new_labels += labels_inference.infer_labels_from_feature_category(test.feature_category) if test.respond_to?(:feature_category)
            up_to_date_labels(test: test, new_labels: new_labels)
          end
        end
      end
    end
  end
end
