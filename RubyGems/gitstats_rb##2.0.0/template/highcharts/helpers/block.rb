module BlockHelper
  def blocktoc(*args)
    partial :blocktoc, { :blocks => args }
  end

  def block(name,width=6)
    haml_concat("<div id=\"block-#{name.to_s}\" class=\"blockcontainer col-md-#{width} panel panel-default\">")
    yield
    haml_concat('</div>')
  end

  def blocks(*args)
    @toc ||= []
    ret = ""
    args.each do |block|
      @toc << block
      if block_given?
        ret += yield(partial(block))
      else
        ret += partial(block)
      end
    end
    ret
  end
end

self.extend BlockHelper
