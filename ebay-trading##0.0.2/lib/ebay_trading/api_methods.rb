
module EbayTrading
  module ApiMethods
    # Builds EbayTrading::Requests#AddDispute
    #
    # Returns EbayTrading::Responses#AddDispute
    #
    # Official Documentation for AddDispute[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/AddDispute.html]
    def add_dispute(params = {})
      commit(EbayTrading::Requests::AddDispute, params)
    end
    # Builds EbayTrading::Requests#AddDisputeResponse
    #
    # Returns EbayTrading::Responses#AddDisputeResponse
    #
    # Official Documentation for AddDisputeResponse[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/AddDisputeResponse.html]
    def add_dispute_response(params = {})
      commit(EbayTrading::Requests::AddDisputeResponse, params)
    end
    # Builds EbayTrading::Requests#AddFixedPriceItem
    #
    # Returns EbayTrading::Responses#AddFixedPriceItem
    #
    # Official Documentation for AddFixedPriceItem[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/AddFixedPriceItem.html]
    def add_fixed_price_item(params = {})
      commit(EbayTrading::Requests::AddFixedPriceItem, params)
    end
    # Builds EbayTrading::Requests#AddItem
    #
    # Returns EbayTrading::Responses#AddItem
    #
    # Official Documentation for AddItem[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/AddItem.html]
    def add_item(params = {})
      commit(EbayTrading::Requests::AddItem, params)
    end
    # Builds EbayTrading::Requests#AddItemFromSellingManagerTemplate
    #
    # Returns EbayTrading::Responses#AddItemFromSellingManagerTemplate
    #
    # Official Documentation for AddItemFromSellingManagerTemplate[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/AddItemFromSellingManagerTemplate.html]
    def add_item_from_selling_manager_template(params = {})
      commit(EbayTrading::Requests::AddItemFromSellingManagerTemplate, params)
    end
    # Builds EbayTrading::Requests#AddItems
    #
    # Returns EbayTrading::Responses#AddItems
    #
    # Official Documentation for AddItems[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/AddItems.html]
    def add_items(params = {})
      commit(EbayTrading::Requests::AddItems, params)
    end
    # Builds EbayTrading::Requests#AddMemberMessageAAQToPartner
    #
    # Returns EbayTrading::Responses#AddMemberMessageAAQToPartner
    #
    # Official Documentation for AddMemberMessageAAQToPartner[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/AddMemberMessageAAQToPartner.html]
    def add_member_message_aaq_to_partner(params = {})
      commit(EbayTrading::Requests::AddMemberMessageAAQToPartner, params)
    end
    # Builds EbayTrading::Requests#AddMemberMessageRTQ
    #
    # Returns EbayTrading::Responses#AddMemberMessageRTQ
    #
    # Official Documentation for AddMemberMessageRTQ[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/AddMemberMessageRTQ.html]
    def add_member_message_rtq(params = {})
      commit(EbayTrading::Requests::AddMemberMessageRTQ, params)
    end
    # Builds EbayTrading::Requests#AddMemberMessagesAAQToBidder
    #
    # Returns EbayTrading::Responses#AddMemberMessagesAAQToBidder
    #
    # Official Documentation for AddMemberMessagesAAQToBidder[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/AddMemberMessagesAAQToBidder.html]
    def add_member_messages_aaq_to_bidder(params = {})
      commit(EbayTrading::Requests::AddMemberMessagesAAQToBidder, params)
    end
    # Builds EbayTrading::Requests#AddOrder
    #
    # Returns EbayTrading::Responses#AddOrder
    #
    # Official Documentation for AddOrder[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/AddOrder.html]
    def add_order(params = {})
      commit(EbayTrading::Requests::AddOrder, params)
    end
    # Builds EbayTrading::Requests#AddSecondChanceItem
    #
    # Returns EbayTrading::Responses#AddSecondChanceItem
    #
    # Official Documentation for AddSecondChanceItem[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/AddSecondChanceItem.html]
    def add_second_chance_item(params = {})
      commit(EbayTrading::Requests::AddSecondChanceItem, params)
    end
    # Builds EbayTrading::Requests#AddSellingManagerInventoryFolder
    #
    # Returns EbayTrading::Responses#AddSellingManagerInventoryFolder
    #
    # Official Documentation for AddSellingManagerInventoryFolder[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/AddSellingManagerInventoryFolder.html]
    def add_selling_manager_inventory_folder(params = {})
      commit(EbayTrading::Requests::AddSellingManagerInventoryFolder, params)
    end
    # Builds EbayTrading::Requests#AddSellingManagerProduct
    #
    # Returns EbayTrading::Responses#AddSellingManagerProduct
    #
    # Official Documentation for AddSellingManagerProduct[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/AddSellingManagerProduct.html]
    def add_selling_manager_product(params = {})
      commit(EbayTrading::Requests::AddSellingManagerProduct, params)
    end
    # Builds EbayTrading::Requests#AddSellingManagerTemplate
    #
    # Returns EbayTrading::Responses#AddSellingManagerTemplate
    #
    # Official Documentation for AddSellingManagerTemplate[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/AddSellingManagerTemplate.html]
    def add_selling_manager_template(params = {})
      commit(EbayTrading::Requests::AddSellingManagerTemplate, params)
    end
    # Builds EbayTrading::Requests#AddToItemDescription
    #
    # Returns EbayTrading::Responses#AddToItemDescription
    #
    # Official Documentation for AddToItemDescription[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/AddToItemDescription.html]
    def add_to_item_description(params = {})
      commit(EbayTrading::Requests::AddToItemDescription, params)
    end
    # Builds EbayTrading::Requests#AddToWatchList
    #
    # Returns EbayTrading::Responses#AddToWatchList
    #
    # Official Documentation for AddToWatchList[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/AddToWatchList.html]
    def add_to_watch_list(params = {})
      commit(EbayTrading::Requests::AddToWatchList, params)
    end
    # Builds EbayTrading::Requests#AddTransactionConfirmationItem
    #
    # Returns EbayTrading::Responses#AddTransactionConfirmationItem
    #
    # Official Documentation for AddTransactionConfirmationItem[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/AddTransactionConfirmationItem.html]
    def add_transaction_confirmation_item(params = {})
      commit(EbayTrading::Requests::AddTransactionConfirmationItem, params)
    end
    # Builds EbayTrading::Requests#CompleteSale
    #
    # Returns EbayTrading::Responses#CompleteSale
    #
    # Official Documentation for CompleteSale[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/CompleteSale.html]
    def complete_sale(params = {})
      commit(EbayTrading::Requests::CompleteSale, params)
    end
    # Builds EbayTrading::Requests#ConfirmIdentity
    #
    # Returns EbayTrading::Responses#ConfirmIdentity
    #
    # Official Documentation for ConfirmIdentity[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/ConfirmIdentity.html]
    def confirm_identity(params = {})
      commit(EbayTrading::Requests::ConfirmIdentity, params)
    end
    # Builds EbayTrading::Requests#DeleteMyMessages
    #
    # Returns EbayTrading::Responses#DeleteMyMessages
    #
    # Official Documentation for DeleteMyMessages[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/DeleteMyMessages.html]
    def delete_my_messages(params = {})
      commit(EbayTrading::Requests::DeleteMyMessages, params)
    end
    # Builds EbayTrading::Requests#DeleteSellingManagerInventoryFolder
    #
    # Returns EbayTrading::Responses#DeleteSellingManagerInventoryFolder
    #
    # Official Documentation for DeleteSellingManagerInventoryFolder[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/DeleteSellingManagerInventoryFolder.html]
    def delete_selling_manager_inventory_folder(params = {})
      commit(EbayTrading::Requests::DeleteSellingManagerInventoryFolder, params)
    end
    # Builds EbayTrading::Requests#DeleteSellingManagerItemAutomationRule
    #
    # Returns EbayTrading::Responses#DeleteSellingManagerItemAutomationRule
    #
    # Official Documentation for DeleteSellingManagerItemAutomationRule[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/DeleteSellingManagerItemAutomationRule.html]
    def delete_selling_manager_item_automation_rule(params = {})
      commit(EbayTrading::Requests::DeleteSellingManagerItemAutomationRule, params)
    end
    # Builds EbayTrading::Requests#DeleteSellingManagerProduct
    #
    # Returns EbayTrading::Responses#DeleteSellingManagerProduct
    #
    # Official Documentation for DeleteSellingManagerProduct[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/DeleteSellingManagerProduct.html]
    def delete_selling_manager_product(params = {})
      commit(EbayTrading::Requests::DeleteSellingManagerProduct, params)
    end
    # Builds EbayTrading::Requests#DeleteSellingManagerTemplate
    #
    # Returns EbayTrading::Responses#DeleteSellingManagerTemplate
    #
    # Official Documentation for DeleteSellingManagerTemplate[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/DeleteSellingManagerTemplate.html]
    def delete_selling_manager_template(params = {})
      commit(EbayTrading::Requests::DeleteSellingManagerTemplate, params)
    end
    # Builds EbayTrading::Requests#DeleteSellingManagerTemplateAutomationRule
    #
    # Returns EbayTrading::Responses#DeleteSellingManagerTemplateAutomationRule
    #
    # Official Documentation for DeleteSellingManagerTemplateAutomationRule[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/DeleteSellingManagerTemplateAutomationRule.html]
    def delete_selling_manager_template_automation_rule(params = {})
      commit(EbayTrading::Requests::DeleteSellingManagerTemplateAutomationRule, params)
    end
    # Builds EbayTrading::Requests#DisableUnpaidItemAssistance
    #
    # Returns EbayTrading::Responses#DisableUnpaidItemAssistance
    #
    # Official Documentation for DisableUnpaidItemAssistance[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/DisableUnpaidItemAssistance.html]
    def disable_unpaid_item_assistance(params = {})
      commit(EbayTrading::Requests::DisableUnpaidItemAssistance, params)
    end
    # Builds EbayTrading::Requests#EndFixedPriceItem
    #
    # Returns EbayTrading::Responses#EndFixedPriceItem
    #
    # Official Documentation for EndFixedPriceItem[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/EndFixedPriceItem.html]
    def end_fixed_price_item(params = {})
      commit(EbayTrading::Requests::EndFixedPriceItem, params)
    end
    # Builds EbayTrading::Requests#EndItem
    #
    # Returns EbayTrading::Responses#EndItem
    #
    # Official Documentation for EndItem[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/EndItem.html]
    def end_item(params = {})
      commit(EbayTrading::Requests::EndItem, params)
    end
    # Builds EbayTrading::Requests#EndItems
    #
    # Returns EbayTrading::Responses#EndItems
    #
    # Official Documentation for EndItems[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/EndItems.html]
    def end_items(params = {})
      commit(EbayTrading::Requests::EndItems, params)
    end
    # Builds EbayTrading::Requests#ExtendSiteHostedPictures
    #
    # Returns EbayTrading::Responses#ExtendSiteHostedPictures
    #
    # Official Documentation for ExtendSiteHostedPictures[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/ExtendSiteHostedPictures.html]
    def extend_site_hosted_pictures(params = {})
      commit(EbayTrading::Requests::ExtendSiteHostedPictures, params)
    end
    # Builds EbayTrading::Requests#FetchToken
    #
    # Returns EbayTrading::Responses#FetchToken
    #
    # Official Documentation for FetchToken[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/FetchToken.html]
    def fetch_token(params = {})
      commit(EbayTrading::Requests::FetchToken, params)
    end
    # Builds EbayTrading::Requests#GetAccount
    #
    # Returns EbayTrading::Responses#GetAccount
    #
    # Official Documentation for GetAccount[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetAccount.html]
    def get_account(params = {})
      commit(EbayTrading::Requests::GetAccount, params)
    end
    # Builds EbayTrading::Requests#GetAdFormatLeads
    #
    # Returns EbayTrading::Responses#GetAdFormatLeads
    #
    # Official Documentation for GetAdFormatLeads[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetAdFormatLeads.html]
    def get_ad_format_leads(params = {})
      commit(EbayTrading::Requests::GetAdFormatLeads, params)
    end
    # Builds EbayTrading::Requests#GetAllBidders
    #
    # Returns EbayTrading::Responses#GetAllBidders
    #
    # Official Documentation for GetAllBidders[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetAllBidders.html]
    def get_all_bidders(params = {})
      commit(EbayTrading::Requests::GetAllBidders, params)
    end
    # Builds EbayTrading::Requests#GetApiAccessRules
    #
    # Returns EbayTrading::Responses#GetApiAccessRules
    #
    # Official Documentation for GetApiAccessRules[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetApiAccessRules.html]
    def get_api_access_rules(params = {})
      commit(EbayTrading::Requests::GetApiAccessRules, params)
    end
    # Builds EbayTrading::Requests#GetAttributesCS
    #
    # Returns EbayTrading::Responses#GetAttributesCS
    #
    # Official Documentation for GetAttributesCS[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetAttributesCS.html]
    def get_attributes_cs(params = {})
      commit(EbayTrading::Requests::GetAttributesCS, params)
    end
    # Builds EbayTrading::Requests#GetAttributesXSL
    #
    # Returns EbayTrading::Responses#GetAttributesXSL
    #
    # Official Documentation for GetAttributesXSL[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetAttributesXSL.html]
    def get_attributes_xsl(params = {})
      commit(EbayTrading::Requests::GetAttributesXSL, params)
    end
    # Builds EbayTrading::Requests#GetBestOffers
    #
    # Returns EbayTrading::Responses#GetBestOffers
    #
    # Official Documentation for GetBestOffers[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetBestOffers.html]
    def get_best_offers(params = {})
      commit(EbayTrading::Requests::GetBestOffers, params)
    end
    # Builds EbayTrading::Requests#GetBidderList
    #
    # Returns EbayTrading::Responses#GetBidderList
    #
    # Official Documentation for GetBidderList[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetBidderList.html]
    def get_bidder_list(params = {})
      commit(EbayTrading::Requests::GetBidderList, params)
    end
    # Builds EbayTrading::Requests#GetCategories
    #
    # Returns EbayTrading::Responses#GetCategories
    #
    # Official Documentation for GetCategories[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetCategories.html]
    def get_categories(params = {})
      commit(EbayTrading::Requests::GetCategories, params)
    end
    # Builds EbayTrading::Requests#GetCategory2CS
    #
    # Returns EbayTrading::Responses#GetCategory2CS
    #
    # Official Documentation for GetCategory2CS[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetCategory2CS.html]
    def get_category2_cs(params = {})
      commit(EbayTrading::Requests::GetCategory2CS, params)
    end
    # Builds EbayTrading::Requests#GetCategoryFeatures
    #
    # Returns EbayTrading::Responses#GetCategoryFeatures
    #
    # Official Documentation for GetCategoryFeatures[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetCategoryFeatures.html]
    def get_category_features(params = {})
      commit(EbayTrading::Requests::GetCategoryFeatures, params)
    end
    # Builds EbayTrading::Requests#GetCategoryMappings
    #
    # Returns EbayTrading::Responses#GetCategoryMappings
    #
    # Official Documentation for GetCategoryMappings[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetCategoryMappings.html]
    def get_category_mappings(params = {})
      commit(EbayTrading::Requests::GetCategoryMappings, params)
    end
    # Builds EbayTrading::Requests#GetCategorySpecifics
    #
    # Returns EbayTrading::Responses#GetCategorySpecifics
    #
    # Official Documentation for GetCategorySpecifics[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetCategorySpecifics.html]
    def get_category_specifics(params = {})
      commit(EbayTrading::Requests::GetCategorySpecifics, params)
    end
    # Builds EbayTrading::Requests#GetChallengeToken
    #
    # Returns EbayTrading::Responses#GetChallengeToken
    #
    # Official Documentation for GetChallengeToken[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetChallengeToken.html]
    def get_challenge_token(params = {})
      commit(EbayTrading::Requests::GetChallengeToken, params)
    end
    # Builds EbayTrading::Requests#GetCharities
    #
    # Returns EbayTrading::Responses#GetCharities
    #
    # Official Documentation for GetCharities[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetCharities.html]
    def get_charities(params = {})
      commit(EbayTrading::Requests::GetCharities, params)
    end
    # Builds EbayTrading::Requests#GetClientAlertsAuthToken
    #
    # Returns EbayTrading::Responses#GetClientAlertsAuthToken
    #
    # Official Documentation for GetClientAlertsAuthToken[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetClientAlertsAuthToken.html]
    def get_client_alerts_auth_token(params = {})
      commit(EbayTrading::Requests::GetClientAlertsAuthToken, params)
    end
    # Builds EbayTrading::Requests#GetContextualKeywords
    #
    # Returns EbayTrading::Responses#GetContextualKeywords
    #
    # Official Documentation for GetContextualKeywords[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetContextualKeywords.html]
    def get_contextual_keywords(params = {})
      commit(EbayTrading::Requests::GetContextualKeywords, params)
    end
    # Builds EbayTrading::Requests#GetCrossPromotions
    #
    # Returns EbayTrading::Responses#GetCrossPromotions
    #
    # Official Documentation for GetCrossPromotions[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetCrossPromotions.html]
    def get_cross_promotions(params = {})
      commit(EbayTrading::Requests::GetCrossPromotions, params)
    end
    # Builds EbayTrading::Requests#GetDescriptionTemplates
    #
    # Returns EbayTrading::Responses#GetDescriptionTemplates
    #
    # Official Documentation for GetDescriptionTemplates[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetDescriptionTemplates.html]
    def get_description_templates(params = {})
      commit(EbayTrading::Requests::GetDescriptionTemplates, params)
    end
    # Builds EbayTrading::Requests#GetDispute
    #
    # Returns EbayTrading::Responses#GetDispute
    #
    # Official Documentation for GetDispute[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetDispute.html]
    def get_dispute(params = {})
      commit(EbayTrading::Requests::GetDispute, params)
    end
    # Builds EbayTrading::Requests#GetFeedback
    #
    # Returns EbayTrading::Responses#GetFeedback
    #
    # Official Documentation for GetFeedback[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetFeedback.html]
    def get_feedback(params = {})
      commit(EbayTrading::Requests::GetFeedback, params)
    end
    # Builds EbayTrading::Requests#GetHighBidders
    #
    # Returns EbayTrading::Responses#GetHighBidders
    #
    # Official Documentation for GetHighBidders[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetHighBidders.html]
    def get_high_bidders(params = {})
      commit(EbayTrading::Requests::GetHighBidders, params)
    end
    # Builds EbayTrading::Requests#GetItem
    #
    # Returns EbayTrading::Responses#GetItem
    #
    # Official Documentation for GetItem[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetItem.html]
    def get_item(params = {})
      commit(EbayTrading::Requests::GetItem, params)
    end
    # Builds EbayTrading::Requests#GetItemRecommendations
    #
    # Returns EbayTrading::Responses#GetItemRecommendations
    #
    # Official Documentation for GetItemRecommendations[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetItemRecommendations.html]
    def get_item_recommendations(params = {})
      commit(EbayTrading::Requests::GetItemRecommendations, params)
    end
    # Builds EbayTrading::Requests#GetItemShipping
    #
    # Returns EbayTrading::Responses#GetItemShipping
    #
    # Official Documentation for GetItemShipping[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetItemShipping.html]
    def get_item_shipping(params = {})
      commit(EbayTrading::Requests::GetItemShipping, params)
    end
    # Builds EbayTrading::Requests#GetItemTransactions
    #
    # Returns EbayTrading::Responses#GetItemTransactions
    #
    # Official Documentation for GetItemTransactions[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetItemTransactions.html]
    def get_item_transactions(params = {})
      commit(EbayTrading::Requests::GetItemTransactions, params)
    end
    # Builds EbayTrading::Requests#GetItemsAwaitingFeedback
    #
    # Returns EbayTrading::Responses#GetItemsAwaitingFeedback
    #
    # Official Documentation for GetItemsAwaitingFeedback[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetItemsAwaitingFeedback.html]
    def get_items_awaiting_feedback(params = {})
      commit(EbayTrading::Requests::GetItemsAwaitingFeedback, params)
    end
    # Builds EbayTrading::Requests#GetMemberMessages
    #
    # Returns EbayTrading::Responses#GetMemberMessages
    #
    # Official Documentation for GetMemberMessages[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetMemberMessages.html]
    def get_member_messages(params = {})
      commit(EbayTrading::Requests::GetMemberMessages, params)
    end
    # Builds EbayTrading::Requests#GetMessagePreferences
    #
    # Returns EbayTrading::Responses#GetMessagePreferences
    #
    # Official Documentation for GetMessagePreferences[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetMessagePreferences.html]
    def get_message_preferences(params = {})
      commit(EbayTrading::Requests::GetMessagePreferences, params)
    end
    # Builds EbayTrading::Requests#GetMyMessages
    #
    # Returns EbayTrading::Responses#GetMyMessages
    #
    # Official Documentation for GetMyMessages[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetMyMessages.html]
    def get_my_messages(params = {})
      commit(EbayTrading::Requests::GetMyMessages, params)
    end
    # Builds EbayTrading::Requests#GetMyeBayBuying
    #
    # Returns EbayTrading::Responses#GetMyeBayBuying
    #
    # Official Documentation for GetMyeBayBuying[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetMyeBayBuying.html]
    def get_my_ebay_buying(params = {})
      commit(EbayTrading::Requests::GetMyeBayBuying, params)
    end
    # Builds EbayTrading::Requests#GetMyeBayReminders
    #
    # Returns EbayTrading::Responses#GetMyeBayReminders
    #
    # Official Documentation for GetMyeBayReminders[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetMyeBayReminders.html]
    def get_my_ebay_reminders(params = {})
      commit(EbayTrading::Requests::GetMyeBayReminders, params)
    end
    # Builds EbayTrading::Requests#GetMyeBaySelling
    #
    # Returns EbayTrading::Responses#GetMyeBaySelling
    #
    # Official Documentation for GetMyeBaySelling[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetMyeBaySelling.html]
    def get_my_ebay_selling(params = {})
      commit(EbayTrading::Requests::GetMyeBaySelling, params)
    end
    # Builds EbayTrading::Requests#GetNotificationPreferences
    #
    # Returns EbayTrading::Responses#GetNotificationPreferences
    #
    # Official Documentation for GetNotificationPreferences[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetNotificationPreferences.html]
    def get_notification_preferences(params = {})
      commit(EbayTrading::Requests::GetNotificationPreferences, params)
    end
    # Builds EbayTrading::Requests#GetNotificationsUsage
    #
    # Returns EbayTrading::Responses#GetNotificationsUsage
    #
    # Official Documentation for GetNotificationsUsage[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetNotificationsUsage.html]
    def get_notifications_usage(params = {})
      commit(EbayTrading::Requests::GetNotificationsUsage, params)
    end
    # Builds EbayTrading::Requests#GetOrderTransactions
    #
    # Returns EbayTrading::Responses#GetOrderTransactions
    #
    # Official Documentation for GetOrderTransactions[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetOrderTransactions.html]
    def get_order_transactions(params = {})
      commit(EbayTrading::Requests::GetOrderTransactions, params)
    end
    # Builds EbayTrading::Requests#GetOrders
    #
    # Returns EbayTrading::Responses#GetOrders
    #
    # Official Documentation for GetOrders[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetOrders.html]
    def get_orders(params = {})
      commit(EbayTrading::Requests::GetOrders, params)
    end
    # Builds EbayTrading::Requests#GetPictureManagerDetails
    #
    # Returns EbayTrading::Responses#GetPictureManagerDetails
    #
    # Official Documentation for GetPictureManagerDetails[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetPictureManagerDetails.html]
    def get_picture_manager_details(params = {})
      commit(EbayTrading::Requests::GetPictureManagerDetails, params)
    end
    # Builds EbayTrading::Requests#GetPictureManagerOptions
    #
    # Returns EbayTrading::Responses#GetPictureManagerOptions
    #
    # Official Documentation for GetPictureManagerOptions[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetPictureManagerOptions.html]
    def get_picture_manager_options(params = {})
      commit(EbayTrading::Requests::GetPictureManagerOptions, params)
    end
    # Builds EbayTrading::Requests#GetProductFamilyMembers
    #
    # Returns EbayTrading::Responses#GetProductFamilyMembers
    #
    # Official Documentation for GetProductFamilyMembers[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetProductFamilyMembers.html]
    def get_product_family_members(params = {})
      commit(EbayTrading::Requests::GetProductFamilyMembers, params)
    end
    # Builds EbayTrading::Requests#GetProductFinder
    #
    # Returns EbayTrading::Responses#GetProductFinder
    #
    # Official Documentation for GetProductFinder[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetProductFinder.html]
    def get_product_finder(params = {})
      commit(EbayTrading::Requests::GetProductFinder, params)
    end
    # Builds EbayTrading::Requests#GetProductFinderXSL
    #
    # Returns EbayTrading::Responses#GetProductFinderXSL
    #
    # Official Documentation for GetProductFinderXSL[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetProductFinderXSL.html]
    def get_product_finder_xsl(params = {})
      commit(EbayTrading::Requests::GetProductFinderXSL, params)
    end
    # Builds EbayTrading::Requests#GetProductSearchPage
    #
    # Returns EbayTrading::Responses#GetProductSearchPage
    #
    # Official Documentation for GetProductSearchPage[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetProductSearchPage.html]
    def get_product_search_page(params = {})
      commit(EbayTrading::Requests::GetProductSearchPage, params)
    end
    # Builds EbayTrading::Requests#GetProductSearchResults
    #
    # Returns EbayTrading::Responses#GetProductSearchResults
    #
    # Official Documentation for GetProductSearchResults[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetProductSearchResults.html]
    def get_product_search_results(params = {})
      commit(EbayTrading::Requests::GetProductSearchResults, params)
    end
    # Builds EbayTrading::Requests#GetProductSellingPages
    #
    # Returns EbayTrading::Responses#GetProductSellingPages
    #
    # Official Documentation for GetProductSellingPages[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetProductSellingPages.html]
    def get_product_selling_pages(params = {})
      commit(EbayTrading::Requests::GetProductSellingPages, params)
    end
    # Builds EbayTrading::Requests#GetPromotionRules
    #
    # Returns EbayTrading::Responses#GetPromotionRules
    #
    # Official Documentation for GetPromotionRules[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetPromotionRules.html]
    def get_promotion_rules(params = {})
      commit(EbayTrading::Requests::GetPromotionRules, params)
    end
    # Builds EbayTrading::Requests#GetPromotionalSaleDetails
    #
    # Returns EbayTrading::Responses#GetPromotionalSaleDetails
    #
    # Official Documentation for GetPromotionalSaleDetails[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetPromotionalSaleDetails.html]
    def get_promotional_sale_details(params = {})
      commit(EbayTrading::Requests::GetPromotionalSaleDetails, params)
    end
    # Builds EbayTrading::Requests#GetSellerDashboard
    #
    # Returns EbayTrading::Responses#GetSellerDashboard
    #
    # Official Documentation for GetSellerDashboard[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetSellerDashboard.html]
    def get_seller_dashboard(params = {})
      commit(EbayTrading::Requests::GetSellerDashboard, params)
    end
    # Builds EbayTrading::Requests#GetSellerEvents
    #
    # Returns EbayTrading::Responses#GetSellerEvents
    #
    # Official Documentation for GetSellerEvents[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetSellerEvents.html]
    def get_seller_events(params = {})
      commit(EbayTrading::Requests::GetSellerEvents, params)
    end
    # Builds EbayTrading::Requests#GetSellerList
    #
    # Returns EbayTrading::Responses#GetSellerList
    #
    # Official Documentation for GetSellerList[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetSellerList.html]
    def get_seller_list(params = {})
      commit(EbayTrading::Requests::GetSellerList, params)
    end
    # Builds EbayTrading::Requests#GetSellerPayments
    #
    # Returns EbayTrading::Responses#GetSellerPayments
    #
    # Official Documentation for GetSellerPayments[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetSellerPayments.html]
    def get_seller_payments(params = {})
      commit(EbayTrading::Requests::GetSellerPayments, params)
    end
    # Builds EbayTrading::Requests#GetSellerTransactions
    #
    # Returns EbayTrading::Responses#GetSellerTransactions
    #
    # Official Documentation for GetSellerTransactions[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetSellerTransactions.html]
    def get_seller_transactions(params = {})
      commit(EbayTrading::Requests::GetSellerTransactions, params)
    end
    # Builds EbayTrading::Requests#GetSellingManagerAlerts
    #
    # Returns EbayTrading::Responses#GetSellingManagerAlerts
    #
    # Official Documentation for GetSellingManagerAlerts[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetSellingManagerAlerts.html]
    def get_selling_manager_alerts(params = {})
      commit(EbayTrading::Requests::GetSellingManagerAlerts, params)
    end
    # Builds EbayTrading::Requests#GetSellingManagerEmailLog
    #
    # Returns EbayTrading::Responses#GetSellingManagerEmailLog
    #
    # Official Documentation for GetSellingManagerEmailLog[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetSellingManagerEmailLog.html]
    def get_selling_manager_email_log(params = {})
      commit(EbayTrading::Requests::GetSellingManagerEmailLog, params)
    end
    # Builds EbayTrading::Requests#GetSellingManagerInventory
    #
    # Returns EbayTrading::Responses#GetSellingManagerInventory
    #
    # Official Documentation for GetSellingManagerInventory[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetSellingManagerInventory.html]
    def get_selling_manager_inventory(params = {})
      commit(EbayTrading::Requests::GetSellingManagerInventory, params)
    end
    # Builds EbayTrading::Requests#GetSellingManagerInventoryFolder
    #
    # Returns EbayTrading::Responses#GetSellingManagerInventoryFolder
    #
    # Official Documentation for GetSellingManagerInventoryFolder[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetSellingManagerInventoryFolder.html]
    def get_selling_manager_inventory_folder(params = {})
      commit(EbayTrading::Requests::GetSellingManagerInventoryFolder, params)
    end
    # Builds EbayTrading::Requests#GetSellingManagerItemAutomationRule
    #
    # Returns EbayTrading::Responses#GetSellingManagerItemAutomationRule
    #
    # Official Documentation for GetSellingManagerItemAutomationRule[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetSellingManagerItemAutomationRule.html]
    def get_selling_manager_item_automation_rule(params = {})
      commit(EbayTrading::Requests::GetSellingManagerItemAutomationRule, params)
    end
    # Builds EbayTrading::Requests#GetSellingManagerSaleRecord
    #
    # Returns EbayTrading::Responses#GetSellingManagerSaleRecord
    #
    # Official Documentation for GetSellingManagerSaleRecord[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetSellingManagerSaleRecord.html]
    def get_selling_manager_sale_record(params = {})
      commit(EbayTrading::Requests::GetSellingManagerSaleRecord, params)
    end
    # Builds EbayTrading::Requests#GetSellingManagerSoldListings
    #
    # Returns EbayTrading::Responses#GetSellingManagerSoldListings
    #
    # Official Documentation for GetSellingManagerSoldListings[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetSellingManagerSoldListings.html]
    def get_selling_manager_sold_listings(params = {})
      commit(EbayTrading::Requests::GetSellingManagerSoldListings, params)
    end
    # Builds EbayTrading::Requests#GetSellingManagerTemplateAutomationRule
    #
    # Returns EbayTrading::Responses#GetSellingManagerTemplateAutomationRule
    #
    # Official Documentation for GetSellingManagerTemplateAutomationRule[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetSellingManagerTemplateAutomationRule.html]
    def get_selling_manager_template_automation_rule(params = {})
      commit(EbayTrading::Requests::GetSellingManagerTemplateAutomationRule, params)
    end
    # Builds EbayTrading::Requests#GetSellingManagerTemplates
    #
    # Returns EbayTrading::Responses#GetSellingManagerTemplates
    #
    # Official Documentation for GetSellingManagerTemplates[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetSellingManagerTemplates.html]
    def get_selling_manager_templates(params = {})
      commit(EbayTrading::Requests::GetSellingManagerTemplates, params)
    end
    # Builds EbayTrading::Requests#GetSessionID
    #
    # Returns EbayTrading::Responses#GetSessionID
    #
    # Official Documentation for GetSessionID[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetSessionID.html]
    def get_session_id(params = {})
      commit(EbayTrading::Requests::GetSessionID, params)
    end
    # Builds EbayTrading::Requests#GetShippingDiscountProfiles
    #
    # Returns EbayTrading::Responses#GetShippingDiscountProfiles
    #
    # Official Documentation for GetShippingDiscountProfiles[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetShippingDiscountProfiles.html]
    def get_shipping_discount_profiles(params = {})
      commit(EbayTrading::Requests::GetShippingDiscountProfiles, params)
    end
    # Builds EbayTrading::Requests#GetStore
    #
    # Returns EbayTrading::Responses#GetStore
    #
    # Official Documentation for GetStore[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetStore.html]
    def get_store(params = {})
      commit(EbayTrading::Requests::GetStore, params)
    end
    # Builds EbayTrading::Requests#GetStoreCategoryUpdateStatus
    #
    # Returns EbayTrading::Responses#GetStoreCategoryUpdateStatus
    #
    # Official Documentation for GetStoreCategoryUpdateStatus[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetStoreCategoryUpdateStatus.html]
    def get_store_category_update_status(params = {})
      commit(EbayTrading::Requests::GetStoreCategoryUpdateStatus, params)
    end
    # Builds EbayTrading::Requests#GetStoreCustomPage
    #
    # Returns EbayTrading::Responses#GetStoreCustomPage
    #
    # Official Documentation for GetStoreCustomPage[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetStoreCustomPage.html]
    def get_store_custom_page(params = {})
      commit(EbayTrading::Requests::GetStoreCustomPage, params)
    end
    # Builds EbayTrading::Requests#GetStoreOptions
    #
    # Returns EbayTrading::Responses#GetStoreOptions
    #
    # Official Documentation for GetStoreOptions[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetStoreOptions.html]
    def get_store_options(params = {})
      commit(EbayTrading::Requests::GetStoreOptions, params)
    end
    # Builds EbayTrading::Requests#GetStorePreferences
    #
    # Returns EbayTrading::Responses#GetStorePreferences
    #
    # Official Documentation for GetStorePreferences[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetStorePreferences.html]
    def get_store_preferences(params = {})
      commit(EbayTrading::Requests::GetStorePreferences, params)
    end
    # Builds EbayTrading::Requests#GetSuggestedCategories
    #
    # Returns EbayTrading::Responses#GetSuggestedCategories
    #
    # Official Documentation for GetSuggestedCategories[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetSuggestedCategories.html]
    def get_suggested_categories(params = {})
      commit(EbayTrading::Requests::GetSuggestedCategories, params)
    end
    # Builds EbayTrading::Requests#GetTaxTable
    #
    # Returns EbayTrading::Responses#GetTaxTable
    #
    # Official Documentation for GetTaxTable[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetTaxTable.html]
    def get_tax_table(params = {})
      commit(EbayTrading::Requests::GetTaxTable, params)
    end
    # Builds EbayTrading::Requests#GetTokenStatus
    #
    # Returns EbayTrading::Responses#GetTokenStatus
    #
    # Official Documentation for GetTokenStatus[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetTokenStatus.html]
    def get_token_status(params = {})
      commit(EbayTrading::Requests::GetTokenStatus, params)
    end
    # Builds EbayTrading::Requests#GetUser
    #
    # Returns EbayTrading::Responses#GetUser
    #
    # Official Documentation for GetUser[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetUser.html]
    def get_user(params = {})
      commit(EbayTrading::Requests::GetUser, params)
    end
    # Builds EbayTrading::Requests#GetUserContactDetails
    #
    # Returns EbayTrading::Responses#GetUserContactDetails
    #
    # Official Documentation for GetUserContactDetails[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetUserContactDetails.html]
    def get_user_contact_details(params = {})
      commit(EbayTrading::Requests::GetUserContactDetails, params)
    end
    # Builds EbayTrading::Requests#GetUserDisputes
    #
    # Returns EbayTrading::Responses#GetUserDisputes
    #
    # Official Documentation for GetUserDisputes[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetUserDisputes.html]
    def get_user_disputes(params = {})
      commit(EbayTrading::Requests::GetUserDisputes, params)
    end
    # Builds EbayTrading::Requests#GetUserPreferences
    #
    # Returns EbayTrading::Responses#GetUserPreferences
    #
    # Official Documentation for GetUserPreferences[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetUserPreferences.html]
    def get_user_preferences(params = {})
      commit(EbayTrading::Requests::GetUserPreferences, params)
    end
    # Builds EbayTrading::Requests#GetVeROReasonCodeDetails
    #
    # Returns EbayTrading::Responses#GetVeROReasonCodeDetails
    #
    # Official Documentation for GetVeROReasonCodeDetails[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetVeROReasonCodeDetails.html]
    def get_vero_reason_code_details(params = {})
      commit(EbayTrading::Requests::GetVeROReasonCodeDetails, params)
    end
    # Builds EbayTrading::Requests#GetVeROReportStatus
    #
    # Returns EbayTrading::Responses#GetVeROReportStatus
    #
    # Official Documentation for GetVeROReportStatus[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetVeROReportStatus.html]
    def get_vero_report_status(params = {})
      commit(EbayTrading::Requests::GetVeROReportStatus, params)
    end
    # Builds EbayTrading::Requests#GetWantItNowPost
    #
    # Returns EbayTrading::Responses#GetWantItNowPost
    #
    # Official Documentation for GetWantItNowPost[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetWantItNowPost.html]
    def get_want_it_now_post(params = {})
      commit(EbayTrading::Requests::GetWantItNowPost, params)
    end
    # Builds EbayTrading::Requests#GetWantItNowSearchResults
    #
    # Returns EbayTrading::Responses#GetWantItNowSearchResults
    #
    # Official Documentation for GetWantItNowSearchResults[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GetWantItNowSearchResults.html]
    def get_want_it_now_search_results(params = {})
      commit(EbayTrading::Requests::GetWantItNowSearchResults, params)
    end
    # Builds EbayTrading::Requests#GeteBayDetails
    #
    # Returns EbayTrading::Responses#GeteBayDetails
    #
    # Official Documentation for GeteBayDetails[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GeteBayDetails.html]
    def get_ebay_details(params = {})
      commit(EbayTrading::Requests::GeteBayDetails, params)
    end
    # Builds EbayTrading::Requests#GeteBayOfficialTime
    #
    # Returns EbayTrading::Responses#GeteBayOfficialTime
    #
    # Official Documentation for GeteBayOfficialTime[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/GeteBayOfficialTime.html]
    def get_ebay_official_time(params = {})
      commit(EbayTrading::Requests::GeteBayOfficialTime, params)
    end
    # Builds EbayTrading::Requests#IssueRefund
    #
    # Returns EbayTrading::Responses#IssueRefund
    #
    # Official Documentation for IssueRefund[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/IssueRefund.html]
    def issue_refund(params = {})
      commit(EbayTrading::Requests::IssueRefund, params)
    end
    # Builds EbayTrading::Requests#LeaveFeedback
    #
    # Returns EbayTrading::Responses#LeaveFeedback
    #
    # Official Documentation for LeaveFeedback[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/LeaveFeedback.html]
    def leave_feedback(params = {})
      commit(EbayTrading::Requests::LeaveFeedback, params)
    end
    # Builds EbayTrading::Requests#MoveSellingManagerInventoryFolder
    #
    # Returns EbayTrading::Responses#MoveSellingManagerInventoryFolder
    #
    # Official Documentation for MoveSellingManagerInventoryFolder[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/MoveSellingManagerInventoryFolder.html]
    def move_selling_manager_inventory_folder(params = {})
      commit(EbayTrading::Requests::MoveSellingManagerInventoryFolder, params)
    end
    # Builds EbayTrading::Requests#PlaceOffer
    #
    # Returns EbayTrading::Responses#PlaceOffer
    #
    # Official Documentation for PlaceOffer[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/PlaceOffer.html]
    def place_offer(params = {})
      commit(EbayTrading::Requests::PlaceOffer, params)
    end
    # Builds EbayTrading::Requests#RelistFixedPriceItem
    #
    # Returns EbayTrading::Responses#RelistFixedPriceItem
    #
    # Official Documentation for RelistFixedPriceItem[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/RelistFixedPriceItem.html]
    def relist_fixed_price_item(params = {})
      commit(EbayTrading::Requests::RelistFixedPriceItem, params)
    end
    # Builds EbayTrading::Requests#RelistItem
    #
    # Returns EbayTrading::Responses#RelistItem
    #
    # Official Documentation for RelistItem[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/RelistItem.html]
    def relist_item(params = {})
      commit(EbayTrading::Requests::RelistItem, params)
    end
    # Builds EbayTrading::Requests#RemoveFromWatchList
    #
    # Returns EbayTrading::Responses#RemoveFromWatchList
    #
    # Official Documentation for RemoveFromWatchList[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/RemoveFromWatchList.html]
    def remove_from_watch_list(params = {})
      commit(EbayTrading::Requests::RemoveFromWatchList, params)
    end
    # Builds EbayTrading::Requests#RespondToBestOffer
    #
    # Returns EbayTrading::Responses#RespondToBestOffer
    #
    # Official Documentation for RespondToBestOffer[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/RespondToBestOffer.html]
    def respond_to_best_offer(params = {})
      commit(EbayTrading::Requests::RespondToBestOffer, params)
    end
    # Builds EbayTrading::Requests#RespondToFeedback
    #
    # Returns EbayTrading::Responses#RespondToFeedback
    #
    # Official Documentation for RespondToFeedback[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/RespondToFeedback.html]
    def respond_to_feedback(params = {})
      commit(EbayTrading::Requests::RespondToFeedback, params)
    end
    # Builds EbayTrading::Requests#RespondToWantItNowPost
    #
    # Returns EbayTrading::Responses#RespondToWantItNowPost
    #
    # Official Documentation for RespondToWantItNowPost[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/RespondToWantItNowPost.html]
    def respond_to_want_it_now_post(params = {})
      commit(EbayTrading::Requests::RespondToWantItNowPost, params)
    end
    # Builds EbayTrading::Requests#ReviseCheckoutStatus
    #
    # Returns EbayTrading::Responses#ReviseCheckoutStatus
    #
    # Official Documentation for ReviseCheckoutStatus[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/ReviseCheckoutStatus.html]
    def revise_checkout_status(params = {})
      commit(EbayTrading::Requests::ReviseCheckoutStatus, params)
    end
    # Builds EbayTrading::Requests#ReviseFixedPriceItem
    #
    # Returns EbayTrading::Responses#ReviseFixedPriceItem
    #
    # Official Documentation for ReviseFixedPriceItem[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/ReviseFixedPriceItem.html]
    def revise_fixed_price_item(params = {})
      commit(EbayTrading::Requests::ReviseFixedPriceItem, params)
    end
    # Builds EbayTrading::Requests#ReviseInventoryStatus
    #
    # Returns EbayTrading::Responses#ReviseInventoryStatus
    #
    # Official Documentation for ReviseInventoryStatus[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/ReviseInventoryStatus.html]
    def revise_inventory_status(params = {})
      commit(EbayTrading::Requests::ReviseInventoryStatus, params)
    end
    # Builds EbayTrading::Requests#ReviseItem
    #
    # Returns EbayTrading::Responses#ReviseItem
    #
    # Official Documentation for ReviseItem[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/ReviseItem.html]
    def revise_item(params = {})
      commit(EbayTrading::Requests::ReviseItem, params)
    end
    # Builds EbayTrading::Requests#ReviseMyMessages
    #
    # Returns EbayTrading::Responses#ReviseMyMessages
    #
    # Official Documentation for ReviseMyMessages[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/ReviseMyMessages.html]
    def revise_my_messages(params = {})
      commit(EbayTrading::Requests::ReviseMyMessages, params)
    end
    # Builds EbayTrading::Requests#ReviseMyMessagesFolders
    #
    # Returns EbayTrading::Responses#ReviseMyMessagesFolders
    #
    # Official Documentation for ReviseMyMessagesFolders[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/ReviseMyMessagesFolders.html]
    def revise_my_messages_folders(params = {})
      commit(EbayTrading::Requests::ReviseMyMessagesFolders, params)
    end
    # Builds EbayTrading::Requests#ReviseSellingManagerInventoryFolder
    #
    # Returns EbayTrading::Responses#ReviseSellingManagerInventoryFolder
    #
    # Official Documentation for ReviseSellingManagerInventoryFolder[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/ReviseSellingManagerInventoryFolder.html]
    def revise_selling_manager_inventory_folder(params = {})
      commit(EbayTrading::Requests::ReviseSellingManagerInventoryFolder, params)
    end
    # Builds EbayTrading::Requests#ReviseSellingManagerProduct
    #
    # Returns EbayTrading::Responses#ReviseSellingManagerProduct
    #
    # Official Documentation for ReviseSellingManagerProduct[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/ReviseSellingManagerProduct.html]
    def revise_selling_manager_product(params = {})
      commit(EbayTrading::Requests::ReviseSellingManagerProduct, params)
    end
    # Builds EbayTrading::Requests#ReviseSellingManagerSaleRecord
    #
    # Returns EbayTrading::Responses#ReviseSellingManagerSaleRecord
    #
    # Official Documentation for ReviseSellingManagerSaleRecord[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/ReviseSellingManagerSaleRecord.html]
    def revise_selling_manager_sale_record(params = {})
      commit(EbayTrading::Requests::ReviseSellingManagerSaleRecord, params)
    end
    # Builds EbayTrading::Requests#ReviseSellingManagerTemplate
    #
    # Returns EbayTrading::Responses#ReviseSellingManagerTemplate
    #
    # Official Documentation for ReviseSellingManagerTemplate[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/ReviseSellingManagerTemplate.html]
    def revise_selling_manager_template(params = {})
      commit(EbayTrading::Requests::ReviseSellingManagerTemplate, params)
    end
    # Builds EbayTrading::Requests#RevokeToken
    #
    # Returns EbayTrading::Responses#RevokeToken
    #
    # Official Documentation for RevokeToken[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/RevokeToken.html]
    def revoke_token(params = {})
      commit(EbayTrading::Requests::RevokeToken, params)
    end
    # Builds EbayTrading::Requests#SaveItemToSellingManagerTemplate
    #
    # Returns EbayTrading::Responses#SaveItemToSellingManagerTemplate
    #
    # Official Documentation for SaveItemToSellingManagerTemplate[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/SaveItemToSellingManagerTemplate.html]
    def save_item_to_selling_manager_template(params = {})
      commit(EbayTrading::Requests::SaveItemToSellingManagerTemplate, params)
    end
    # Builds EbayTrading::Requests#SellerReverseDispute
    #
    # Returns EbayTrading::Responses#SellerReverseDispute
    #
    # Official Documentation for SellerReverseDispute[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/SellerReverseDispute.html]
    def seller_reverse_dispute(params = {})
      commit(EbayTrading::Requests::SellerReverseDispute, params)
    end
    # Builds EbayTrading::Requests#SendInvoice
    #
    # Returns EbayTrading::Responses#SendInvoice
    #
    # Official Documentation for SendInvoice[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/SendInvoice.html]
    def send_invoice(params = {})
      commit(EbayTrading::Requests::SendInvoice, params)
    end
    # Builds EbayTrading::Requests#SetMessagePreferences
    #
    # Returns EbayTrading::Responses#SetMessagePreferences
    #
    # Official Documentation for SetMessagePreferences[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/SetMessagePreferences.html]
    def set_message_preferences(params = {})
      commit(EbayTrading::Requests::SetMessagePreferences, params)
    end
    # Builds EbayTrading::Requests#SetNotificationPreferences
    #
    # Returns EbayTrading::Responses#SetNotificationPreferences
    #
    # Official Documentation for SetNotificationPreferences[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/SetNotificationPreferences.html]
    def set_notification_preferences(params = {})
      commit(EbayTrading::Requests::SetNotificationPreferences, params)
    end
    # Builds EbayTrading::Requests#SetPictureManagerDetails
    #
    # Returns EbayTrading::Responses#SetPictureManagerDetails
    #
    # Official Documentation for SetPictureManagerDetails[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/SetPictureManagerDetails.html]
    def set_picture_manager_details(params = {})
      commit(EbayTrading::Requests::SetPictureManagerDetails, params)
    end
    # Builds EbayTrading::Requests#SetPromotionalSale
    #
    # Returns EbayTrading::Responses#SetPromotionalSale
    #
    # Official Documentation for SetPromotionalSale[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/SetPromotionalSale.html]
    def set_promotional_sale(params = {})
      commit(EbayTrading::Requests::SetPromotionalSale, params)
    end
    # Builds EbayTrading::Requests#SetPromotionalSaleListings
    #
    # Returns EbayTrading::Responses#SetPromotionalSaleListings
    #
    # Official Documentation for SetPromotionalSaleListings[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/SetPromotionalSaleListings.html]
    def set_promotional_sale_listings(params = {})
      commit(EbayTrading::Requests::SetPromotionalSaleListings, params)
    end
    # Builds EbayTrading::Requests#SetSellingManagerFeedbackOptions
    #
    # Returns EbayTrading::Responses#SetSellingManagerFeedbackOptions
    #
    # Official Documentation for SetSellingManagerFeedbackOptions[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/SetSellingManagerFeedbackOptions.html]
    def set_selling_manager_feedback_options(params = {})
      commit(EbayTrading::Requests::SetSellingManagerFeedbackOptions, params)
    end
    # Builds EbayTrading::Requests#SetSellingManagerItemAutomationRule
    #
    # Returns EbayTrading::Responses#SetSellingManagerItemAutomationRule
    #
    # Official Documentation for SetSellingManagerItemAutomationRule[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/SetSellingManagerItemAutomationRule.html]
    def set_selling_manager_item_automation_rule(params = {})
      commit(EbayTrading::Requests::SetSellingManagerItemAutomationRule, params)
    end
    # Builds EbayTrading::Requests#SetSellingManagerTemplateAutomationRule
    #
    # Returns EbayTrading::Responses#SetSellingManagerTemplateAutomationRule
    #
    # Official Documentation for SetSellingManagerTemplateAutomationRule[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/SetSellingManagerTemplateAutomationRule.html]
    def set_selling_manager_template_automation_rule(params = {})
      commit(EbayTrading::Requests::SetSellingManagerTemplateAutomationRule, params)
    end
    # Builds EbayTrading::Requests#SetShippingDiscountProfiles
    #
    # Returns EbayTrading::Responses#SetShippingDiscountProfiles
    #
    # Official Documentation for SetShippingDiscountProfiles[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/SetShippingDiscountProfiles.html]
    def set_shipping_discount_profiles(params = {})
      commit(EbayTrading::Requests::SetShippingDiscountProfiles, params)
    end
    # Builds EbayTrading::Requests#SetStore
    #
    # Returns EbayTrading::Responses#SetStore
    #
    # Official Documentation for SetStore[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/SetStore.html]
    def set_store(params = {})
      commit(EbayTrading::Requests::SetStore, params)
    end
    # Builds EbayTrading::Requests#SetStoreCategories
    #
    # Returns EbayTrading::Responses#SetStoreCategories
    #
    # Official Documentation for SetStoreCategories[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/SetStoreCategories.html]
    def set_store_categories(params = {})
      commit(EbayTrading::Requests::SetStoreCategories, params)
    end
    # Builds EbayTrading::Requests#SetStoreCustomPage
    #
    # Returns EbayTrading::Responses#SetStoreCustomPage
    #
    # Official Documentation for SetStoreCustomPage[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/SetStoreCustomPage.html]
    def set_store_custom_page(params = {})
      commit(EbayTrading::Requests::SetStoreCustomPage, params)
    end
    # Builds EbayTrading::Requests#SetStorePreferences
    #
    # Returns EbayTrading::Responses#SetStorePreferences
    #
    # Official Documentation for SetStorePreferences[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/SetStorePreferences.html]
    def set_store_preferences(params = {})
      commit(EbayTrading::Requests::SetStorePreferences, params)
    end
    # Builds EbayTrading::Requests#SetTaxTable
    #
    # Returns EbayTrading::Responses#SetTaxTable
    #
    # Official Documentation for SetTaxTable[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/SetTaxTable.html]
    def set_tax_table(params = {})
      commit(EbayTrading::Requests::SetTaxTable, params)
    end
    # Builds EbayTrading::Requests#SetUserNotes
    #
    # Returns EbayTrading::Responses#SetUserNotes
    #
    # Official Documentation for SetUserNotes[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/SetUserNotes.html]
    def set_user_notes(params = {})
      commit(EbayTrading::Requests::SetUserNotes, params)
    end
    # Builds EbayTrading::Requests#SetUserPreferences
    #
    # Returns EbayTrading::Responses#SetUserPreferences
    #
    # Official Documentation for SetUserPreferences[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/SetUserPreferences.html]
    def set_user_preferences(params = {})
      commit(EbayTrading::Requests::SetUserPreferences, params)
    end
    # Builds EbayTrading::Requests#UploadSiteHostedPictures
    #
    # Returns EbayTrading::Responses#UploadSiteHostedPictures
    #
    # Official Documentation for UploadSiteHostedPictures[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/UploadSiteHostedPictures.html]
    def upload_site_hosted_pictures(params = {})
      commit(EbayTrading::Requests::UploadSiteHostedPictures, params)
    end
    # Builds EbayTrading::Requests#ValidateChallengeInput
    #
    # Returns EbayTrading::Responses#ValidateChallengeInput
    #
    # Official Documentation for ValidateChallengeInput[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/ValidateChallengeInput.html]
    def validate_challenge_input(params = {})
      commit(EbayTrading::Requests::ValidateChallengeInput, params)
    end
    # Builds EbayTrading::Requests#ValidateTestUserRegistration
    #
    # Returns EbayTrading::Responses#ValidateTestUserRegistration
    #
    # Official Documentation for ValidateTestUserRegistration[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/ValidateTestUserRegistration.html]
    def validate_test_user_registration(params = {})
      commit(EbayTrading::Requests::ValidateTestUserRegistration, params)
    end
    # Builds EbayTrading::Requests#VeROReportItems
    #
    # Returns EbayTrading::Responses#VeROReportItems
    #
    # Official Documentation for VeROReportItems[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/VeROReportItems.html]
    def vero_report_items(params = {})
      commit(EbayTrading::Requests::VeROReportItems, params)
    end
    # Builds EbayTrading::Requests#VerifyAddFixedPriceItem
    #
    # Returns EbayTrading::Responses#VerifyAddFixedPriceItem
    #
    # Official Documentation for VerifyAddFixedPriceItem[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/VerifyAddFixedPriceItem.html]
    def verify_add_fixed_price_item(params = {})
      commit(EbayTrading::Requests::VerifyAddFixedPriceItem, params)
    end
    # Builds EbayTrading::Requests#VerifyAddItem
    #
    # Returns EbayTrading::Responses#VerifyAddItem
    #
    # Official Documentation for VerifyAddItem[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/VerifyAddItem.html]
    def verify_add_item(params = {})
      commit(EbayTrading::Requests::VerifyAddItem, params)
    end
    # Builds EbayTrading::Requests#VerifyAddSecondChanceItem
    #
    # Returns EbayTrading::Responses#VerifyAddSecondChanceItem
    #
    # Official Documentation for VerifyAddSecondChanceItem[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/VerifyAddSecondChanceItem.html]
    def verify_add_second_chance_item(params = {})
      commit(EbayTrading::Requests::VerifyAddSecondChanceItem, params)
    end
    # Builds EbayTrading::Requests#VerifyRelistItem
    #
    # Returns EbayTrading::Responses#VerifyRelistItem
    #
    # Official Documentation for VerifyRelistItem[http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/VerifyRelistItem.html]
    def verify_relist_item(params = {})
      commit(EbayTrading::Requests::VerifyRelistItem, params)
    end
  end
end
