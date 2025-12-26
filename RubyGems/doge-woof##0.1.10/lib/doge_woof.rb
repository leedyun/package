require_relative "doge_woof/version"

module DogeWoof
  class << self
    @@modifiers = ['so', 'such', 'many', 'much', 'very']
    @@c_modifiers = ['on the road', 'on the internet', 'in the house', 'in the city', 'in the hood', 'around the block']
    @@fillers = ['adorable', 'fancy', 'bright', 'outstanding', 'wicked', 'clever', 'fantastic']
    @@words = ['memory', 'bulb', 'TV', 'city', 'river', 'cake', 'Ruby', 'friends', 'sweets', 'meme', 'fashion', 'swag', 'muvee', 'money', 'Africa', 'politics']
    @@c_words = ['wow', 'excite', 'amaze']

    def generate(type, count)
      case type
        when "phrase"
          phrase(count)
        when "line"
          line(count)
        when "para"
          para(count)
      end
    end

    def phrase(count = 2)
      woof = ""
      count.times do
        woof += @@modifiers.sample.capitalize + " " + @@words.sample + ". "
      end
      woof += @@c_words.sample.capitalize + "."
      return woof_result = {"result" => woof}
    end

    def line(count = 3)
      woof = ""
      count.times do
        woof += @@modifiers.sample.capitalize + " " + @@fillers.sample + " " + @@words.sample + " " + @@c_modifiers.sample + ". "
        woof += @@c_words.sample.capitalize + ". " if rand < 0.3
      end
      return woof_result = {"result" => woof}
    end

    def para(para_count = 2, line_count = 15)
      woof = ""
      para_count.times do
        line_count.times do
          woof += @@modifiers.sample.capitalize + " " + @@fillers.sample + " " + @@words.sample + " " + @@c_modifiers.sample + ". "
          woof += @@c_words.sample.capitalize + ". " if rand < 0.5
        end
        woof += "\n\n"
      end
      return woof_result = {"result" => woof}
    end

  end
end
