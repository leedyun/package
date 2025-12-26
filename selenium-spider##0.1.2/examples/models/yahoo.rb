class Yahoo < SeleniumSpider::Model
  register :AAA do |attr|
    attr.css = 'th:contains("AAA") + td'
  end

  register :BBB do |attr|
    attr.css = 'th:contains("BBB") + td'
    attr.match = '^b+c'
  end
end

