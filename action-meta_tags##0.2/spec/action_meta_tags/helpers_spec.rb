require 'spec_helper'

module Meta
  module Post
    class Show < ActionMetaTags::Base
      title { title }
    end
  end
end

RSpec.describe ActionMetaTags::Helpers do
  describe '#meta_tags' do
    let(:view) do
      ActionView::Base.new.tap do |view|
        params = { controller: 'posts', action: 'show' }
        view.controller = OpenStruct.new(params: params)
      end
    end
    let(:resource) { OpenStruct.new(title: 'Title') }
    subject { view.meta_tags(resource) }

    specify do
      is_expected.to eq('<title>Title</title>')
    end
  end
end
