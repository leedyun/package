require 'tilt'

class BatchIt
  VERSION = File.read(File.join(File.dirname(__FILE__),"..","VERSION")).freeze

  attr_reader :corpus
  def initialize(corpus)
    @corpus = corpus
    @erb_template, @markdown_template = Tilt.templates_for("corpus.markdown.erb")
  end

  def result(data)
    enumerate_over_bindings(data) do |bind|
      markdown_result(erb_result(corpus, bind))
    end
  end

  private
  def enumerate_over_bindings(input)
    case input
    when Array
      input.map do |item|
        yield(item)
      end
    else
      yield(input)
    end
  end

  def markdown_template(corpus)
    @markdown_template.new{corpus}
  end

  def markdown_result(corpus)
    markdown_template(corpus).render
  end

  def erb_result(corpus, data)
    erb(corpus).render(data)
  end

  def erb(corpus)
    @erb ||= @erb_template.new("corpus.erb", trim: false) { corpus }
  end
end
