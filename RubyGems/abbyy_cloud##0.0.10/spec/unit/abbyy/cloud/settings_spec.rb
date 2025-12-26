RSpec.describe ABBYY::Cloud::Settings do
  let(:options)  { { id: "foo", token: "bar" } }
  let(:settings) { described_class.new options }

  describe ".new" do
    subject { settings }

    context "without id" do
      before { options.delete :id }

      it "fails" do
        expect { subject }.to raise_error(StandardError)
      end
    end

    context "without token" do
      before { options.delete :token }

      it "fails" do
        expect { subject }.to raise_error(StandardError)
      end
    end

    context "with empty id" do
      before { options[:id] = nil }

      it "fails" do
        expect { subject }.to raise_error(StandardError)
      end
    end

    context "with empty token" do
      before { options[:token] = nil }

      it "fails" do
        expect { subject }.to raise_error(StandardError)
      end
    end
  end

  describe "#id" do
    subject { settings.id }
    it { is_expected.to eq "foo" }
  end

  describe "#token" do
    subject { settings.token }
    it { is_expected.to eq "bar" }
  end

  describe "#engine" do
    subject { settings.engine }

    context "by default:" do
      it { is_expected.to eq "Sandbox" }
    end

    context "when assigned:" do
      before { options[:engine] = "Google" }
      it { is_expected.to eq "Google" }
    end
  end

  describe "#connection" do
    subject { settings.connection }

    it { is_expected.to be_instance_of ABBYY::Cloud::Connection }
    its(:id)    { is_expected.to eq settings.id }
    its(:token) { is_expected.to eq settings.token }
  end
end
