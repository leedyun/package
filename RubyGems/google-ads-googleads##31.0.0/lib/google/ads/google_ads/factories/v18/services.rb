require "google/ads/google_ads/service_wrapper"
require "google/ads/google_ads/version"
module Google
  module Ads
    module GoogleAds
      module Factories
        module V18
          class Services
            def initialize(
              logging_interceptor:,
              error_interceptor:,
              credentials:,
              metadata:,
              endpoint:,
              deprecation:
            )
              @interceptors = [
                error_interceptor,
                logging_interceptor
              ].compact
              @credentials = credentials
              @metadata = metadata
              @endpoint = endpoint
              @deprecation = deprecation
            end

            def have_logging_interceptor?
              @logging_interceptor != nil
            end

            def account_budget_proposal(&blk)
              require "google/ads/google_ads/v18/services/account_budget_proposal_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::AccountBudgetProposalService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_account_budget_proposal: Google::Ads::GoogleAds::V18::Services::MutateAccountBudgetProposalRequest

                },
                deprecation: @deprecation
              )
            end

            def account_link(&blk)
              require "google/ads/google_ads/v18/services/account_link_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::AccountLinkService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  create_account_link: Google::Ads::GoogleAds::V18::Services::CreateAccountLinkRequest,

                  mutate_account_link: Google::Ads::GoogleAds::V18::Services::MutateAccountLinkRequest

                },
                deprecation: @deprecation
              )
            end

            def ad_group_ad_label(&blk)
              require "google/ads/google_ads/v18/services/ad_group_ad_label_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::AdGroupAdLabelService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_ad_group_ad_labels: Google::Ads::GoogleAds::V18::Services::MutateAdGroupAdLabelsRequest

                },
                deprecation: @deprecation
              )
            end

            def ad_group_ad(&blk)
              require "google/ads/google_ads/v18/services/ad_group_ad_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::AdGroupAdService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_ad_group_ads: Google::Ads::GoogleAds::V18::Services::MutateAdGroupAdsRequest,

                  remove_automatically_created_assets: Google::Ads::GoogleAds::V18::Services::RemoveAutomaticallyCreatedAssetsRequest

                },
                deprecation: @deprecation
              )
            end

            def ad_group_asset(&blk)
              require "google/ads/google_ads/v18/services/ad_group_asset_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::AdGroupAssetService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_ad_group_assets: Google::Ads::GoogleAds::V18::Services::MutateAdGroupAssetsRequest

                },
                deprecation: @deprecation
              )
            end

            def ad_group_asset_set(&blk)
              require "google/ads/google_ads/v18/services/ad_group_asset_set_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::AdGroupAssetSetService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_ad_group_asset_sets: Google::Ads::GoogleAds::V18::Services::MutateAdGroupAssetSetsRequest

                },
                deprecation: @deprecation
              )
            end

            def ad_group_bid_modifier(&blk)
              require "google/ads/google_ads/v18/services/ad_group_bid_modifier_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::AdGroupBidModifierService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_ad_group_bid_modifiers: Google::Ads::GoogleAds::V18::Services::MutateAdGroupBidModifiersRequest

                },
                deprecation: @deprecation
              )
            end

            def ad_group_criterion_customizer(&blk)
              require "google/ads/google_ads/v18/services/ad_group_criterion_customizer_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::AdGroupCriterionCustomizerService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_ad_group_criterion_customizers: Google::Ads::GoogleAds::V18::Services::MutateAdGroupCriterionCustomizersRequest

                },
                deprecation: @deprecation
              )
            end

            def ad_group_criterion_label(&blk)
              require "google/ads/google_ads/v18/services/ad_group_criterion_label_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::AdGroupCriterionLabelService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_ad_group_criterion_labels: Google::Ads::GoogleAds::V18::Services::MutateAdGroupCriterionLabelsRequest

                },
                deprecation: @deprecation
              )
            end

            def ad_group_criterion(&blk)
              require "google/ads/google_ads/v18/services/ad_group_criterion_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::AdGroupCriterionService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_ad_group_criteria: Google::Ads::GoogleAds::V18::Services::MutateAdGroupCriteriaRequest

                },
                deprecation: @deprecation
              )
            end

            def ad_group_customizer(&blk)
              require "google/ads/google_ads/v18/services/ad_group_customizer_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::AdGroupCustomizerService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_ad_group_customizers: Google::Ads::GoogleAds::V18::Services::MutateAdGroupCustomizersRequest

                },
                deprecation: @deprecation
              )
            end

            def ad_group_extension_setting(&blk)
              require "google/ads/google_ads/v18/services/ad_group_extension_setting_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::AdGroupExtensionSettingService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_ad_group_extension_settings: Google::Ads::GoogleAds::V18::Services::MutateAdGroupExtensionSettingsRequest

                },
                deprecation: @deprecation
              )
            end

            def ad_group_feed(&blk)
              require "google/ads/google_ads/v18/services/ad_group_feed_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::AdGroupFeedService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_ad_group_feeds: Google::Ads::GoogleAds::V18::Services::MutateAdGroupFeedsRequest

                },
                deprecation: @deprecation
              )
            end

            def ad_group_label(&blk)
              require "google/ads/google_ads/v18/services/ad_group_label_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::AdGroupLabelService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_ad_group_labels: Google::Ads::GoogleAds::V18::Services::MutateAdGroupLabelsRequest

                },
                deprecation: @deprecation
              )
            end

            def ad_group(&blk)
              require "google/ads/google_ads/v18/services/ad_group_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::AdGroupService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_ad_groups: Google::Ads::GoogleAds::V18::Services::MutateAdGroupsRequest

                },
                deprecation: @deprecation
              )
            end

            def ad_parameter(&blk)
              require "google/ads/google_ads/v18/services/ad_parameter_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::AdParameterService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_ad_parameters: Google::Ads::GoogleAds::V18::Services::MutateAdParametersRequest

                },
                deprecation: @deprecation
              )
            end

            def ad(&blk)
              require "google/ads/google_ads/v18/services/ad_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::AdService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_ads: Google::Ads::GoogleAds::V18::Services::MutateAdsRequest

                },
                deprecation: @deprecation
              )
            end

            def asset_group_asset(&blk)
              require "google/ads/google_ads/v18/services/asset_group_asset_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::AssetGroupAssetService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_asset_group_assets: Google::Ads::GoogleAds::V18::Services::MutateAssetGroupAssetsRequest

                },
                deprecation: @deprecation
              )
            end

            def asset_group_listing_group_filter(&blk)
              require "google/ads/google_ads/v18/services/asset_group_listing_group_filter_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::AssetGroupListingGroupFilterService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_asset_group_listing_group_filters: Google::Ads::GoogleAds::V18::Services::MutateAssetGroupListingGroupFiltersRequest

                },
                deprecation: @deprecation
              )
            end

            def asset_group(&blk)
              require "google/ads/google_ads/v18/services/asset_group_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::AssetGroupService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_asset_groups: Google::Ads::GoogleAds::V18::Services::MutateAssetGroupsRequest

                },
                deprecation: @deprecation
              )
            end

            def asset_group_signal(&blk)
              require "google/ads/google_ads/v18/services/asset_group_signal_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::AssetGroupSignalService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_asset_group_signals: Google::Ads::GoogleAds::V18::Services::MutateAssetGroupSignalsRequest

                },
                deprecation: @deprecation
              )
            end

            def asset(&blk)
              require "google/ads/google_ads/v18/services/asset_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::AssetService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_assets: Google::Ads::GoogleAds::V18::Services::MutateAssetsRequest

                },
                deprecation: @deprecation
              )
            end

            def asset_set_asset(&blk)
              require "google/ads/google_ads/v18/services/asset_set_asset_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::AssetSetAssetService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_asset_set_assets: Google::Ads::GoogleAds::V18::Services::MutateAssetSetAssetsRequest

                },
                deprecation: @deprecation
              )
            end

            def asset_set(&blk)
              require "google/ads/google_ads/v18/services/asset_set_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::AssetSetService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_asset_sets: Google::Ads::GoogleAds::V18::Services::MutateAssetSetsRequest

                },
                deprecation: @deprecation
              )
            end

            def audience_insights(&blk)
              require "google/ads/google_ads/v18/services/audience_insights_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::AudienceInsightsService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  generate_insights_finder_report: Google::Ads::GoogleAds::V18::Services::GenerateInsightsFinderReportRequest,

                  list_audience_insights_attributes: Google::Ads::GoogleAds::V18::Services::ListAudienceInsightsAttributesRequest,

                  list_insights_eligible_dates: Google::Ads::GoogleAds::V18::Services::ListInsightsEligibleDatesRequest,

                  generate_audience_composition_insights: Google::Ads::GoogleAds::V18::Services::GenerateAudienceCompositionInsightsRequest,

                  generate_suggested_targeting_insights: Google::Ads::GoogleAds::V18::Services::GenerateSuggestedTargetingInsightsRequest,

                  generate_audience_overlap_insights: Google::Ads::GoogleAds::V18::Services::GenerateAudienceOverlapInsightsRequest,

                  generate_targeting_suggestion_metrics: Google::Ads::GoogleAds::V18::Services::GenerateTargetingSuggestionMetricsRequest

                },
                deprecation: @deprecation
              )
            end

            def audience(&blk)
              require "google/ads/google_ads/v18/services/audience_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::AudienceService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_audiences: Google::Ads::GoogleAds::V18::Services::MutateAudiencesRequest

                },
                deprecation: @deprecation
              )
            end

            def batch_job(&blk)
              require "google/ads/google_ads/v18/services/batch_job_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::BatchJobService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_batch_job: Google::Ads::GoogleAds::V18::Services::MutateBatchJobRequest,

                  list_batch_job_results: Google::Ads::GoogleAds::V18::Services::ListBatchJobResultsRequest,

                  run_batch_job: Google::Ads::GoogleAds::V18::Services::RunBatchJobRequest,

                  add_batch_job_operations: Google::Ads::GoogleAds::V18::Services::AddBatchJobOperationsRequest

                },
                deprecation: @deprecation
              )
            end

            def bidding_data_exclusion(&blk)
              require "google/ads/google_ads/v18/services/bidding_data_exclusion_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::BiddingDataExclusionService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_bidding_data_exclusions: Google::Ads::GoogleAds::V18::Services::MutateBiddingDataExclusionsRequest

                },
                deprecation: @deprecation
              )
            end

            def bidding_seasonality_adjustment(&blk)
              require "google/ads/google_ads/v18/services/bidding_seasonality_adjustment_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::BiddingSeasonalityAdjustmentService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_bidding_seasonality_adjustments: Google::Ads::GoogleAds::V18::Services::MutateBiddingSeasonalityAdjustmentsRequest

                },
                deprecation: @deprecation
              )
            end

            def bidding_strategy(&blk)
              require "google/ads/google_ads/v18/services/bidding_strategy_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::BiddingStrategyService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_bidding_strategies: Google::Ads::GoogleAds::V18::Services::MutateBiddingStrategiesRequest

                },
                deprecation: @deprecation
              )
            end

            def billing_setup(&blk)
              require "google/ads/google_ads/v18/services/billing_setup_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::BillingSetupService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_billing_setup: Google::Ads::GoogleAds::V18::Services::MutateBillingSetupRequest

                },
                deprecation: @deprecation
              )
            end

            def brand_suggestion(&blk)
              require "google/ads/google_ads/v18/services/brand_suggestion_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::BrandSuggestionService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  suggest_brands: Google::Ads::GoogleAds::V18::Services::SuggestBrandsRequest

                },
                deprecation: @deprecation
              )
            end

            def campaign_asset(&blk)
              require "google/ads/google_ads/v18/services/campaign_asset_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::CampaignAssetService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_campaign_assets: Google::Ads::GoogleAds::V18::Services::MutateCampaignAssetsRequest

                },
                deprecation: @deprecation
              )
            end

            def campaign_asset_set(&blk)
              require "google/ads/google_ads/v18/services/campaign_asset_set_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::CampaignAssetSetService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_campaign_asset_sets: Google::Ads::GoogleAds::V18::Services::MutateCampaignAssetSetsRequest

                },
                deprecation: @deprecation
              )
            end

            def campaign_bid_modifier(&blk)
              require "google/ads/google_ads/v18/services/campaign_bid_modifier_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::CampaignBidModifierService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_campaign_bid_modifiers: Google::Ads::GoogleAds::V18::Services::MutateCampaignBidModifiersRequest

                },
                deprecation: @deprecation
              )
            end

            def campaign_budget(&blk)
              require "google/ads/google_ads/v18/services/campaign_budget_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::CampaignBudgetService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_campaign_budgets: Google::Ads::GoogleAds::V18::Services::MutateCampaignBudgetsRequest

                },
                deprecation: @deprecation
              )
            end

            def campaign_conversion_goal(&blk)
              require "google/ads/google_ads/v18/services/campaign_conversion_goal_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::CampaignConversionGoalService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_campaign_conversion_goals: Google::Ads::GoogleAds::V18::Services::MutateCampaignConversionGoalsRequest

                },
                deprecation: @deprecation
              )
            end

            def campaign_criterion(&blk)
              require "google/ads/google_ads/v18/services/campaign_criterion_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::CampaignCriterionService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_campaign_criteria: Google::Ads::GoogleAds::V18::Services::MutateCampaignCriteriaRequest

                },
                deprecation: @deprecation
              )
            end

            def campaign_customizer(&blk)
              require "google/ads/google_ads/v18/services/campaign_customizer_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::CampaignCustomizerService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_campaign_customizers: Google::Ads::GoogleAds::V18::Services::MutateCampaignCustomizersRequest

                },
                deprecation: @deprecation
              )
            end

            def campaign_draft(&blk)
              require "google/ads/google_ads/v18/services/campaign_draft_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::CampaignDraftService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_campaign_drafts: Google::Ads::GoogleAds::V18::Services::MutateCampaignDraftsRequest,

                  promote_campaign_draft: Google::Ads::GoogleAds::V18::Services::PromoteCampaignDraftRequest,

                  list_campaign_draft_async_errors: Google::Ads::GoogleAds::V18::Services::ListCampaignDraftAsyncErrorsRequest

                },
                deprecation: @deprecation
              )
            end

            def campaign_extension_setting(&blk)
              require "google/ads/google_ads/v18/services/campaign_extension_setting_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::CampaignExtensionSettingService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_campaign_extension_settings: Google::Ads::GoogleAds::V18::Services::MutateCampaignExtensionSettingsRequest

                },
                deprecation: @deprecation
              )
            end

            def campaign_feed(&blk)
              require "google/ads/google_ads/v18/services/campaign_feed_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::CampaignFeedService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_campaign_feeds: Google::Ads::GoogleAds::V18::Services::MutateCampaignFeedsRequest

                },
                deprecation: @deprecation
              )
            end

            def campaign_group(&blk)
              require "google/ads/google_ads/v18/services/campaign_group_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::CampaignGroupService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_campaign_groups: Google::Ads::GoogleAds::V18::Services::MutateCampaignGroupsRequest

                },
                deprecation: @deprecation
              )
            end

            def campaign_label(&blk)
              require "google/ads/google_ads/v18/services/campaign_label_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::CampaignLabelService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_campaign_labels: Google::Ads::GoogleAds::V18::Services::MutateCampaignLabelsRequest

                },
                deprecation: @deprecation
              )
            end

            def campaign_lifecycle_goal(&blk)
              require "google/ads/google_ads/v18/services/campaign_lifecycle_goal_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::CampaignLifecycleGoalService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  configure_campaign_lifecycle_goals: Google::Ads::GoogleAds::V18::Services::ConfigureCampaignLifecycleGoalsRequest

                },
                deprecation: @deprecation
              )
            end

            def campaign(&blk)
              require "google/ads/google_ads/v18/services/campaign_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::CampaignService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_campaigns: Google::Ads::GoogleAds::V18::Services::MutateCampaignsRequest

                },
                deprecation: @deprecation
              )
            end

            def campaign_shared_set(&blk)
              require "google/ads/google_ads/v18/services/campaign_shared_set_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::CampaignSharedSetService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_campaign_shared_sets: Google::Ads::GoogleAds::V18::Services::MutateCampaignSharedSetsRequest

                },
                deprecation: @deprecation
              )
            end

            def content_creator_insights(&blk)
              require "google/ads/google_ads/v18/services/content_creator_insights_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::ContentCreatorInsightsService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  generate_creator_insights: Google::Ads::GoogleAds::V18::Services::GenerateCreatorInsightsRequest

                },
                deprecation: @deprecation
              )
            end

            def conversion_action(&blk)
              require "google/ads/google_ads/v18/services/conversion_action_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::ConversionActionService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_conversion_actions: Google::Ads::GoogleAds::V18::Services::MutateConversionActionsRequest

                },
                deprecation: @deprecation
              )
            end

            def conversion_adjustment_upload(&blk)
              require "google/ads/google_ads/v18/services/conversion_adjustment_upload_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::ConversionAdjustmentUploadService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  upload_conversion_adjustments: Google::Ads::GoogleAds::V18::Services::UploadConversionAdjustmentsRequest

                },
                deprecation: @deprecation
              )
            end

            def conversion_custom_variable(&blk)
              require "google/ads/google_ads/v18/services/conversion_custom_variable_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::ConversionCustomVariableService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_conversion_custom_variables: Google::Ads::GoogleAds::V18::Services::MutateConversionCustomVariablesRequest

                },
                deprecation: @deprecation
              )
            end

            def conversion_goal_campaign_config(&blk)
              require "google/ads/google_ads/v18/services/conversion_goal_campaign_config_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::ConversionGoalCampaignConfigService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_conversion_goal_campaign_configs: Google::Ads::GoogleAds::V18::Services::MutateConversionGoalCampaignConfigsRequest

                },
                deprecation: @deprecation
              )
            end

            def conversion_upload(&blk)
              require "google/ads/google_ads/v18/services/conversion_upload_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::ConversionUploadService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  upload_click_conversions: Google::Ads::GoogleAds::V18::Services::UploadClickConversionsRequest,

                  upload_call_conversions: Google::Ads::GoogleAds::V18::Services::UploadCallConversionsRequest

                },
                deprecation: @deprecation
              )
            end

            def conversion_value_rule(&blk)
              require "google/ads/google_ads/v18/services/conversion_value_rule_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::ConversionValueRuleService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_conversion_value_rules: Google::Ads::GoogleAds::V18::Services::MutateConversionValueRulesRequest

                },
                deprecation: @deprecation
              )
            end

            def conversion_value_rule_set(&blk)
              require "google/ads/google_ads/v18/services/conversion_value_rule_set_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::ConversionValueRuleSetService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_conversion_value_rule_sets: Google::Ads::GoogleAds::V18::Services::MutateConversionValueRuleSetsRequest

                },
                deprecation: @deprecation
              )
            end

            def custom_audience(&blk)
              require "google/ads/google_ads/v18/services/custom_audience_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::CustomAudienceService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_custom_audiences: Google::Ads::GoogleAds::V18::Services::MutateCustomAudiencesRequest

                },
                deprecation: @deprecation
              )
            end

            def custom_conversion_goal(&blk)
              require "google/ads/google_ads/v18/services/custom_conversion_goal_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::CustomConversionGoalService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_custom_conversion_goals: Google::Ads::GoogleAds::V18::Services::MutateCustomConversionGoalsRequest

                },
                deprecation: @deprecation
              )
            end

            def custom_interest(&blk)
              require "google/ads/google_ads/v18/services/custom_interest_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::CustomInterestService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_custom_interests: Google::Ads::GoogleAds::V18::Services::MutateCustomInterestsRequest

                },
                deprecation: @deprecation
              )
            end

            def customer_asset(&blk)
              require "google/ads/google_ads/v18/services/customer_asset_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::CustomerAssetService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_customer_assets: Google::Ads::GoogleAds::V18::Services::MutateCustomerAssetsRequest

                },
                deprecation: @deprecation
              )
            end

            def customer_asset_set(&blk)
              require "google/ads/google_ads/v18/services/customer_asset_set_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::CustomerAssetSetService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_customer_asset_sets: Google::Ads::GoogleAds::V18::Services::MutateCustomerAssetSetsRequest

                },
                deprecation: @deprecation
              )
            end

            def customer_client_link(&blk)
              require "google/ads/google_ads/v18/services/customer_client_link_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::CustomerClientLinkService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_customer_client_link: Google::Ads::GoogleAds::V18::Services::MutateCustomerClientLinkRequest

                },
                deprecation: @deprecation
              )
            end

            def customer_conversion_goal(&blk)
              require "google/ads/google_ads/v18/services/customer_conversion_goal_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::CustomerConversionGoalService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_customer_conversion_goals: Google::Ads::GoogleAds::V18::Services::MutateCustomerConversionGoalsRequest

                },
                deprecation: @deprecation
              )
            end

            def customer_customizer(&blk)
              require "google/ads/google_ads/v18/services/customer_customizer_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::CustomerCustomizerService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_customer_customizers: Google::Ads::GoogleAds::V18::Services::MutateCustomerCustomizersRequest

                },
                deprecation: @deprecation
              )
            end

            def customer_extension_setting(&blk)
              require "google/ads/google_ads/v18/services/customer_extension_setting_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::CustomerExtensionSettingService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_customer_extension_settings: Google::Ads::GoogleAds::V18::Services::MutateCustomerExtensionSettingsRequest

                },
                deprecation: @deprecation
              )
            end

            def customer_feed(&blk)
              require "google/ads/google_ads/v18/services/customer_feed_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::CustomerFeedService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_customer_feeds: Google::Ads::GoogleAds::V18::Services::MutateCustomerFeedsRequest

                },
                deprecation: @deprecation
              )
            end

            def customer_label(&blk)
              require "google/ads/google_ads/v18/services/customer_label_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::CustomerLabelService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_customer_labels: Google::Ads::GoogleAds::V18::Services::MutateCustomerLabelsRequest

                },
                deprecation: @deprecation
              )
            end

            def customer_lifecycle_goal(&blk)
              require "google/ads/google_ads/v18/services/customer_lifecycle_goal_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::CustomerLifecycleGoalService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  configure_customer_lifecycle_goals: Google::Ads::GoogleAds::V18::Services::ConfigureCustomerLifecycleGoalsRequest

                },
                deprecation: @deprecation
              )
            end

            def customer_manager_link(&blk)
              require "google/ads/google_ads/v18/services/customer_manager_link_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::CustomerManagerLinkService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_customer_manager_link: Google::Ads::GoogleAds::V18::Services::MutateCustomerManagerLinkRequest,

                  move_manager_link: Google::Ads::GoogleAds::V18::Services::MoveManagerLinkRequest

                },
                deprecation: @deprecation
              )
            end

            def customer_negative_criterion(&blk)
              require "google/ads/google_ads/v18/services/customer_negative_criterion_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::CustomerNegativeCriterionService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_customer_negative_criteria: Google::Ads::GoogleAds::V18::Services::MutateCustomerNegativeCriteriaRequest

                },
                deprecation: @deprecation
              )
            end

            def customer(&blk)
              require "google/ads/google_ads/v18/services/customer_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::CustomerService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_customer: Google::Ads::GoogleAds::V18::Services::MutateCustomerRequest,

                  list_accessible_customers: Google::Ads::GoogleAds::V18::Services::ListAccessibleCustomersRequest,

                  create_customer_client: Google::Ads::GoogleAds::V18::Services::CreateCustomerClientRequest

                },
                deprecation: @deprecation
              )
            end

            def customer_sk_ad_network_conversion_value_schema(&blk)
              require "google/ads/google_ads/v18/services/customer_sk_ad_network_conversion_value_schema_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::CustomerSkAdNetworkConversionValueSchemaService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_customer_sk_ad_network_conversion_value_schema: Google::Ads::GoogleAds::V18::Services::MutateCustomerSkAdNetworkConversionValueSchemaRequest

                },
                deprecation: @deprecation
              )
            end

            def customer_user_access_invitation(&blk)
              require "google/ads/google_ads/v18/services/customer_user_access_invitation_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::CustomerUserAccessInvitationService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_customer_user_access_invitation: Google::Ads::GoogleAds::V18::Services::MutateCustomerUserAccessInvitationRequest

                },
                deprecation: @deprecation
              )
            end

            def customer_user_access(&blk)
              require "google/ads/google_ads/v18/services/customer_user_access_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::CustomerUserAccessService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_customer_user_access: Google::Ads::GoogleAds::V18::Services::MutateCustomerUserAccessRequest

                },
                deprecation: @deprecation
              )
            end

            def customizer_attribute(&blk)
              require "google/ads/google_ads/v18/services/customizer_attribute_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::CustomizerAttributeService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_customizer_attributes: Google::Ads::GoogleAds::V18::Services::MutateCustomizerAttributesRequest

                },
                deprecation: @deprecation
              )
            end

            def data_link(&blk)
              require "google/ads/google_ads/v18/services/data_link_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::DataLinkService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  create_data_link: Google::Ads::GoogleAds::V18::Services::CreateDataLinkRequest

                },
                deprecation: @deprecation
              )
            end

            def experiment_arm(&blk)
              require "google/ads/google_ads/v18/services/experiment_arm_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::ExperimentArmService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_experiment_arms: Google::Ads::GoogleAds::V18::Services::MutateExperimentArmsRequest

                },
                deprecation: @deprecation
              )
            end

            def experiment(&blk)
              require "google/ads/google_ads/v18/services/experiment_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::ExperimentService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_experiments: Google::Ads::GoogleAds::V18::Services::MutateExperimentsRequest,

                  end_experiment: Google::Ads::GoogleAds::V18::Services::EndExperimentRequest,

                  list_experiment_async_errors: Google::Ads::GoogleAds::V18::Services::ListExperimentAsyncErrorsRequest,

                  graduate_experiment: Google::Ads::GoogleAds::V18::Services::GraduateExperimentRequest,

                  schedule_experiment: Google::Ads::GoogleAds::V18::Services::ScheduleExperimentRequest,

                  promote_experiment: Google::Ads::GoogleAds::V18::Services::PromoteExperimentRequest

                },
                deprecation: @deprecation
              )
            end

            def extension_feed_item(&blk)
              require "google/ads/google_ads/v18/services/extension_feed_item_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::ExtensionFeedItemService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_extension_feed_items: Google::Ads::GoogleAds::V18::Services::MutateExtensionFeedItemsRequest

                },
                deprecation: @deprecation
              )
            end

            def feed_item(&blk)
              require "google/ads/google_ads/v18/services/feed_item_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::FeedItemService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_feed_items: Google::Ads::GoogleAds::V18::Services::MutateFeedItemsRequest

                },
                deprecation: @deprecation
              )
            end

            def feed_item_set_link(&blk)
              require "google/ads/google_ads/v18/services/feed_item_set_link_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::FeedItemSetLinkService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_feed_item_set_links: Google::Ads::GoogleAds::V18::Services::MutateFeedItemSetLinksRequest

                },
                deprecation: @deprecation
              )
            end

            def feed_item_set(&blk)
              require "google/ads/google_ads/v18/services/feed_item_set_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::FeedItemSetService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_feed_item_sets: Google::Ads::GoogleAds::V18::Services::MutateFeedItemSetsRequest

                },
                deprecation: @deprecation
              )
            end

            def feed_item_target(&blk)
              require "google/ads/google_ads/v18/services/feed_item_target_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::FeedItemTargetService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_feed_item_targets: Google::Ads::GoogleAds::V18::Services::MutateFeedItemTargetsRequest

                },
                deprecation: @deprecation
              )
            end

            def feed_mapping(&blk)
              require "google/ads/google_ads/v18/services/feed_mapping_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::FeedMappingService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_feed_mappings: Google::Ads::GoogleAds::V18::Services::MutateFeedMappingsRequest

                },
                deprecation: @deprecation
              )
            end

            def feed(&blk)
              require "google/ads/google_ads/v18/services/feed_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::FeedService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_feeds: Google::Ads::GoogleAds::V18::Services::MutateFeedsRequest

                },
                deprecation: @deprecation
              )
            end

            def geo_target_constant(&blk)
              require "google/ads/google_ads/v18/services/geo_target_constant_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::GeoTargetConstantService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  suggest_geo_target_constants: Google::Ads::GoogleAds::V18::Services::SuggestGeoTargetConstantsRequest

                },
                deprecation: @deprecation
              )
            end

            def google_ads_field(&blk)
              require "google/ads/google_ads/v18/services/google_ads_field_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::GoogleAdsFieldService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  get_google_ads_field: Google::Ads::GoogleAds::V18::Services::GetGoogleAdsFieldRequest,

                  search_google_ads_fields: Google::Ads::GoogleAds::V18::Services::SearchGoogleAdsFieldsRequest

                },
                deprecation: @deprecation
              )
            end

            def google_ads(&blk)
              require "google/ads/google_ads/v18/services/google_ads_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::GoogleAdsService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  search: Google::Ads::GoogleAds::V18::Services::SearchGoogleAdsRequest,

                  search_stream: Google::Ads::GoogleAds::V18::Services::SearchGoogleAdsStreamRequest,

                  mutate: Google::Ads::GoogleAds::V18::Services::MutateGoogleAdsRequest

                },
                deprecation: @deprecation
              )
            end

            def identity_verification(&blk)
              require "google/ads/google_ads/v18/services/identity_verification_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::IdentityVerificationService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  start_identity_verification: Google::Ads::GoogleAds::V18::Services::StartIdentityVerificationRequest,

                  get_identity_verification: Google::Ads::GoogleAds::V18::Services::GetIdentityVerificationRequest

                },
                deprecation: @deprecation
              )
            end

            def invoice(&blk)
              require "google/ads/google_ads/v18/services/invoice_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::InvoiceService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  list_invoices: Google::Ads::GoogleAds::V18::Services::ListInvoicesRequest

                },
                deprecation: @deprecation
              )
            end

            def keyword_plan_ad_group_keyword(&blk)
              require "google/ads/google_ads/v18/services/keyword_plan_ad_group_keyword_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::KeywordPlanAdGroupKeywordService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_keyword_plan_ad_group_keywords: Google::Ads::GoogleAds::V18::Services::MutateKeywordPlanAdGroupKeywordsRequest

                },
                deprecation: @deprecation
              )
            end

            def keyword_plan_ad_group(&blk)
              require "google/ads/google_ads/v18/services/keyword_plan_ad_group_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::KeywordPlanAdGroupService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_keyword_plan_ad_groups: Google::Ads::GoogleAds::V18::Services::MutateKeywordPlanAdGroupsRequest

                },
                deprecation: @deprecation
              )
            end

            def keyword_plan_campaign_keyword(&blk)
              require "google/ads/google_ads/v18/services/keyword_plan_campaign_keyword_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::KeywordPlanCampaignKeywordService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_keyword_plan_campaign_keywords: Google::Ads::GoogleAds::V18::Services::MutateKeywordPlanCampaignKeywordsRequest

                },
                deprecation: @deprecation
              )
            end

            def keyword_plan_campaign(&blk)
              require "google/ads/google_ads/v18/services/keyword_plan_campaign_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::KeywordPlanCampaignService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_keyword_plan_campaigns: Google::Ads::GoogleAds::V18::Services::MutateKeywordPlanCampaignsRequest

                },
                deprecation: @deprecation
              )
            end

            def keyword_plan_idea(&blk)
              require "google/ads/google_ads/v18/services/keyword_plan_idea_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::KeywordPlanIdeaService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  generate_keyword_ideas: Google::Ads::GoogleAds::V18::Services::GenerateKeywordIdeasRequest,

                  generate_keyword_historical_metrics: Google::Ads::GoogleAds::V18::Services::GenerateKeywordHistoricalMetricsRequest,

                  generate_ad_group_themes: Google::Ads::GoogleAds::V18::Services::GenerateAdGroupThemesRequest,

                  generate_keyword_forecast_metrics: Google::Ads::GoogleAds::V18::Services::GenerateKeywordForecastMetricsRequest

                },
                deprecation: @deprecation
              )
            end

            def keyword_plan(&blk)
              require "google/ads/google_ads/v18/services/keyword_plan_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::KeywordPlanService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_keyword_plans: Google::Ads::GoogleAds::V18::Services::MutateKeywordPlansRequest

                },
                deprecation: @deprecation
              )
            end

            def keyword_theme_constant(&blk)
              require "google/ads/google_ads/v18/services/keyword_theme_constant_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::KeywordThemeConstantService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  suggest_keyword_theme_constants: Google::Ads::GoogleAds::V18::Services::SuggestKeywordThemeConstantsRequest

                },
                deprecation: @deprecation
              )
            end

            def label(&blk)
              require "google/ads/google_ads/v18/services/label_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::LabelService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_labels: Google::Ads::GoogleAds::V18::Services::MutateLabelsRequest

                },
                deprecation: @deprecation
              )
            end

            def local_services_lead(&blk)
              require "google/ads/google_ads/v18/services/local_services_lead_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::LocalServicesLeadService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  append_lead_conversation: Google::Ads::GoogleAds::V18::Services::AppendLeadConversationRequest

                },
                deprecation: @deprecation
              )
            end

            def offline_user_data_job(&blk)
              require "google/ads/google_ads/v18/services/offline_user_data_job_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::OfflineUserDataJobService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  create_offline_user_data_job: Google::Ads::GoogleAds::V18::Services::CreateOfflineUserDataJobRequest,

                  add_offline_user_data_job_operations: Google::Ads::GoogleAds::V18::Services::AddOfflineUserDataJobOperationsRequest,

                  run_offline_user_data_job: Google::Ads::GoogleAds::V18::Services::RunOfflineUserDataJobRequest

                },
                deprecation: @deprecation
              )
            end

            def payments_account(&blk)
              require "google/ads/google_ads/v18/services/payments_account_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::PaymentsAccountService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  list_payments_accounts: Google::Ads::GoogleAds::V18::Services::ListPaymentsAccountsRequest

                },
                deprecation: @deprecation
              )
            end

            def product_link_invitation(&blk)
              require "google/ads/google_ads/v18/services/product_link_invitation_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::ProductLinkInvitationService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  create_product_link_invitation: Google::Ads::GoogleAds::V18::Services::CreateProductLinkInvitationRequest,

                  update_product_link_invitation: Google::Ads::GoogleAds::V18::Services::UpdateProductLinkInvitationRequest,

                  remove_product_link_invitation: Google::Ads::GoogleAds::V18::Services::RemoveProductLinkInvitationRequest

                },
                deprecation: @deprecation
              )
            end

            def product_link(&blk)
              require "google/ads/google_ads/v18/services/product_link_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::ProductLinkService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  create_product_link: Google::Ads::GoogleAds::V18::Services::CreateProductLinkRequest,

                  remove_product_link: Google::Ads::GoogleAds::V18::Services::RemoveProductLinkRequest

                },
                deprecation: @deprecation
              )
            end

            def reach_plan(&blk)
              require "google/ads/google_ads/v18/services/reach_plan_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::ReachPlanService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  list_plannable_locations: Google::Ads::GoogleAds::V18::Services::ListPlannableLocationsRequest,

                  list_plannable_products: Google::Ads::GoogleAds::V18::Services::ListPlannableProductsRequest,

                  generate_reach_forecast: Google::Ads::GoogleAds::V18::Services::GenerateReachForecastRequest

                },
                deprecation: @deprecation
              )
            end

            def recommendation(&blk)
              require "google/ads/google_ads/v18/services/recommendation_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::RecommendationService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  apply_recommendation: Google::Ads::GoogleAds::V18::Services::ApplyRecommendationRequest,

                  dismiss_recommendation: Google::Ads::GoogleAds::V18::Services::DismissRecommendationRequest,

                  generate_recommendations: Google::Ads::GoogleAds::V18::Services::GenerateRecommendationsRequest

                },
                deprecation: @deprecation
              )
            end

            def recommendation_subscription(&blk)
              require "google/ads/google_ads/v18/services/recommendation_subscription_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::RecommendationSubscriptionService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_recommendation_subscription: Google::Ads::GoogleAds::V18::Services::MutateRecommendationSubscriptionRequest

                },
                deprecation: @deprecation
              )
            end

            def remarketing_action(&blk)
              require "google/ads/google_ads/v18/services/remarketing_action_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::RemarketingActionService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_remarketing_actions: Google::Ads::GoogleAds::V18::Services::MutateRemarketingActionsRequest

                },
                deprecation: @deprecation
              )
            end

            def shareable_preview(&blk)
              require "google/ads/google_ads/v18/services/shareable_preview_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::ShareablePreviewService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  generate_shareable_previews: Google::Ads::GoogleAds::V18::Services::GenerateShareablePreviewsRequest

                },
                deprecation: @deprecation
              )
            end

            def shared_criterion(&blk)
              require "google/ads/google_ads/v18/services/shared_criterion_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::SharedCriterionService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_shared_criteria: Google::Ads::GoogleAds::V18::Services::MutateSharedCriteriaRequest

                },
                deprecation: @deprecation
              )
            end

            def shared_set(&blk)
              require "google/ads/google_ads/v18/services/shared_set_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::SharedSetService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_shared_sets: Google::Ads::GoogleAds::V18::Services::MutateSharedSetsRequest

                },
                deprecation: @deprecation
              )
            end

            def smart_campaign_setting(&blk)
              require "google/ads/google_ads/v18/services/smart_campaign_setting_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::SmartCampaignSettingService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  get_smart_campaign_status: Google::Ads::GoogleAds::V18::Services::GetSmartCampaignStatusRequest,

                  mutate_smart_campaign_settings: Google::Ads::GoogleAds::V18::Services::MutateSmartCampaignSettingsRequest

                },
                deprecation: @deprecation
              )
            end

            def smart_campaign_suggest(&blk)
              require "google/ads/google_ads/v18/services/smart_campaign_suggest_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::SmartCampaignSuggestService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  suggest_smart_campaign_budget_options: Google::Ads::GoogleAds::V18::Services::SuggestSmartCampaignBudgetOptionsRequest,

                  suggest_smart_campaign_ad: Google::Ads::GoogleAds::V18::Services::SuggestSmartCampaignAdRequest,

                  suggest_keyword_themes: Google::Ads::GoogleAds::V18::Services::SuggestKeywordThemesRequest

                },
                deprecation: @deprecation
              )
            end

            def third_party_app_analytics_link(&blk)
              require "google/ads/google_ads/v18/services/third_party_app_analytics_link_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::ThirdPartyAppAnalyticsLinkService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  regenerate_shareable_link_id: Google::Ads::GoogleAds::V18::Services::RegenerateShareableLinkIdRequest

                },
                deprecation: @deprecation
              )
            end

            def travel_asset_suggestion(&blk)
              require "google/ads/google_ads/v18/services/travel_asset_suggestion_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::TravelAssetSuggestionService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  suggest_travel_assets: Google::Ads::GoogleAds::V18::Services::SuggestTravelAssetsRequest

                },
                deprecation: @deprecation
              )
            end

            def user_data(&blk)
              require "google/ads/google_ads/v18/services/user_data_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::UserDataService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  upload_user_data: Google::Ads::GoogleAds::V18::Services::UploadUserDataRequest

                },
                deprecation: @deprecation
              )
            end

            def user_list_customer_type(&blk)
              require "google/ads/google_ads/v18/services/user_list_customer_type_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::UserListCustomerTypeService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_user_list_customer_types: Google::Ads::GoogleAds::V18::Services::MutateUserListCustomerTypesRequest

                },
                deprecation: @deprecation
              )
            end

            def user_list(&blk)
              require "google/ads/google_ads/v18/services/user_list_service"
              svc = ServiceWrapper.new(
                service: Google::Ads::GoogleAds::V18::Services::UserListService::Client.new do |config|
                  config.credentials = @credentials
                  config.interceptors = @interceptors
                  config.metadata = @metadata
                  config.endpoint = @endpoint
                  config.lib_name = Google::Ads::GoogleAds::CLIENT_LIB_NAME
                  config.lib_version = Google::Ads::GoogleAds::CLIENT_LIB_VERSION
                end,
                rpc_inputs: {

                  mutate_user_lists: Google::Ads::GoogleAds::V18::Services::MutateUserListsRequest

                },
                deprecation: @deprecation
              )
            end
          end
        end
      end
    end
  end
end
