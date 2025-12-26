Given(/^this deak of cards defined to check$/) do |table|
  @deck= table.raw
end

When(/^I list the cards$/) do
  @game = Game.new
  @card_list =[]

  @game.cards_collection.keys.each do |key|
		@card_list.push [key]
  end

end
Then(/^all should be included$/) do
	expect(@card_list).to match_array(@deck)

end

Then(/^they should be a total of (\d+)$/) do |total_cards|
  expect(@game.cards_collection.count).to eq(total_cards.to_i)
end