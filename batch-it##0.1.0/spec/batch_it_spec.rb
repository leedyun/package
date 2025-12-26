require 'spec_helper'

describe BatchIt do
  it 'should have a version number' do
    expect(BatchIt::VERSION).to_not be_nil
  end

  context "with some markdown" do
    let(:markdown) do
      File.read(__FILE__).split(/^__END__$/,2).last
    end

    let(:batch_it) { described_class.new(markdown) }

    context "#result with a scalar" do
      let(:scalar) { double(title: "The Title", subtitle: "Nonsense", quote: "Emergency Solution") }

      subject { batch_it.result(scalar) }

      it "should have the title in an h1" do
        expect(subject).to include("<h1>The Title</h1>")
      end

      it "should have the subtitle in an h2" do
        expect(subject).to include("<h2>Nonsense</h2>")
      end

      it "should have the quote" do
        expect(subject).to include("<p>Emergency Solution</p>")
      end
    end

    context "#result with an enumerable" do
      let(:enumerable) { [double(title: "The Title", subtitle: "Nonsense", quote: "Emergency Solution"), double(title: "The Title 2", subtitle: "Nonsense 2", quote: "Emergency Solution 2")]}

      subject { batch_it.result(enumerable) }

      it "should have as many items as in the enumerable" do
        expect(subject.length).to eql(enumerable.length)
      end

      it "should render the corpus for each element" do
        expect(subject.first).to include("<h1>The Title</h1>")
        expect(subject.last).to  include("<h1>The Title 2</h1>")
      end
    end
  end
end

__END__
<%= title %>
=

<%= subtitle %>
-

> <%= quote %>
