require 'spec_helper'

class ResourceTags < ActionMetaTags::Base
  title { "#{title} | Site" }

  meta('http-equiv' => 'refresh') { "0;URL='http://example.com/'".html_safe }

  keywords       { 'key,words' }
  description    { description }
  og_title       { title }
  og_image       { 'http://example.org/i.png' }
  og_description { description }

  link(
    rel: 'search',
    type: 'application/opensearchdescription+xml',
    title: 'Site') { '/opensearch.xml' }
end

RSpec.describe ActionMetaTags::Base do
  let(:view)     { ActionView::Base.new }
  let(:resource) { OpenStruct.new(title: 'Title', description: 'Lorem Ipsum.') }
  subject        { ResourceTags.new(resource).render(view) }

  specify '#title renders the title tag' do
    is_expected.to include('<title>Title | Site</title>')
  end

  specify '#meta renders a meta tag' do
    is_expected.to include(%q(<meta http-equiv="refresh" content="0;URL='http://example.com/'" />))
  end

  specify '#link renders a link tag' do
    is_expected.to include('<link rel="search" type="application/opensearchdescription+xml" title="Site" href="/opensearch.xml" />')
  end

  specify '#keywords renders the appropriate meta tag' do
    is_expected.to include('<meta name="keywords" content="key,words" />')
  end

  specify '#description renders the appropriate meta tag' do
    is_expected.to include('<meta name="description" content="Lorem Ipsum." />')
  end

  specify '#og_title renders the appropriate meta tag' do
    is_expected.to include('<meta property="og:title" content="Title" />')
  end

  specify '#og_image renders the appropriate meta tag' do
    is_expected.to include('<meta property="og:image" content="http://example.org/i.png" />')
  end

  specify '#og_description renders the appropriate meta tag' do
    is_expected.to include('<meta property="og:description" content="Lorem Ipsum." />')
  end
end
