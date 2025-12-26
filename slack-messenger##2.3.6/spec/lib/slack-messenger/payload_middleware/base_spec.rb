# frozen_string_literal: true

RSpec.describe Slack::Messenger::PayloadMiddleware::Base do
  before(:each) do
    @registry_backup = Slack::Messenger::PayloadMiddleware.registry.dup
    Slack::Messenger::PayloadMiddleware.send(:remove_instance_variable, :@registry)
  end

  after(:each) do
    # cleanup middleware registry
    Slack::Messenger::PayloadMiddleware.registry
    Slack::Messenger::PayloadMiddleware.send(:remove_instance_variable, :@registry)

    # cleanup object constants
    Object.send(:remove_const, :Subject) if Object.constants.include?(:Subject)
    Slack::Messenger::PayloadMiddleware.send(:instance_variable_set, :@registry, @registry_backup)
  end

  describe "::middleware_name" do
    it "registers class w/ given name" do
      class Subject < Slack::Messenger::PayloadMiddleware::Base
      end

      expect(Slack::Messenger::PayloadMiddleware)
        .to receive(:register).with(Subject, :subject)

      class Subject
        middleware_name :subject
      end
    end

    it "uses symbolized name to register" do
      class Subject < Slack::Messenger::PayloadMiddleware::Base
      end

      expect(Slack::Messenger::PayloadMiddleware)
        .to receive(:register).with(Subject, :subject)

      class Subject
        middleware_name "subject"
      end
    end
  end

  describe "::options" do
    it "allows setting default options for a middleware" do
      class Subject < Slack::Messenger::PayloadMiddleware::Base
        options foo: :bar
      end

      subject = Subject.new(:messenger)
      expect(subject.options).to eq foo: :bar

      subject = Subject.new(:messenger, foo: :baz)
      expect(subject.options).to eq foo: :baz
    end
  end

  describe "#initialize" do
    it "sets given messenger as messenger" do
      expect(described_class.new(:messenger).messenger).to eq :messenger
    end

    it "sets given options as opts" do
      expect(described_class.new(:messenger, opts: :options).options).to eq opts: :options
    end
  end

  describe "#call" do
    it "raises NoMethodError (expects subclass to define)" do
      expect do
        described_class.new(:messenger).call
      end.to raise_exception NoMethodError
    end
  end
end
