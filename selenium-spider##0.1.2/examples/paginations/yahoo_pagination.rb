class YahooPagination < SeleniumSpider::Pagination
  next_link 'Next'
  detail_links 'li a[href*="detail"]'
end

