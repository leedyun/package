require 'spec_helper'

RSpec.describe ActionMetaTags::Tags::SelfClosingTag do
  let(:view)     { ActionView::Base.new }
  let(:resource) { OpenStruct.new(url: 'http://example.org/') }
  subject(:tag)  { described_class.new(rel: :canonical) { url } }

  specify do
    expect { tag.render(view, resource) }.to raise_error(NotImplementedError)
  end
end
