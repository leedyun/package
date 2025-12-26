require 'spec_helper'

RSpec.describe ActionMetaTags::Tags::Title do
  let(:view)     { ActionView::Base.new }
  let(:resource) { OpenStruct.new(title: 'Title') }
  subject(:tag)  { described_class.new { title } }

  specify do
    expect(tag.render(view, resource)).to eq('<title>Title</title>')
  end
end
