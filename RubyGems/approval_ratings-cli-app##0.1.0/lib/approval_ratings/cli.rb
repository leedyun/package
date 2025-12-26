require 'pry'
class ApprovalRatings::CLI
  def call
    start
  end

  def list
    puts ""
    puts "************* President Trump Approval Ratings *************"
    puts ""
    ApprovalRatings::Rating.all.each.with_index(1) do |rating, i|
      puts "#{i}. #{rating.name} on #{rating.date}" 
    end
    puts ""
  end

  def print_rating(rating)
    rating.each do |rating|

      puts ""
      puts "-------------- #{rating.name} --------------"
      puts "poll date"      
      puts rating.date
      puts ""
      puts "pollster grade"
      puts rating.summary
      puts ""
      puts "approval rating"
      puts rating.approval
      puts ""
      puts "disapproval rating"
      puts rating.disapproval
      puts ""
    end
  end

  def print_rating_i(rating)   

      puts ""
      puts "-------------- #{rating.name} --------------"      
      puts "poll date"      
      puts rating.date
      puts ""
      puts "pollster grade"
      puts rating.summary
      puts ""
      puts "approval rating"
      puts rating.approval
      puts ""
      puts "disapproval rating"
      puts rating.disapproval
      puts ""
    
  end

  def start
    list
    input = nil
    while input != "exit"
      puts ""
      puts "What poll would you more information on, by name or number?"
      puts ""
      puts "Enter list to see the polls again."
      puts "Enter exit to end the program."
      puts ""
      input = gets.strip
      if input == "list"
        list
      elsif input.to_i == 0
        if rating = ApprovalRatings::Rating.find_by_name(input)          
          print_rating(rating)
          
        end 
      elsif input.to_i > 0
        if rating = ApprovalRatings::Rating.find(input.to_i)
          print_rating_i(rating)
        end
      end
    end
    puts "Goodbye!!!"
  end


end
