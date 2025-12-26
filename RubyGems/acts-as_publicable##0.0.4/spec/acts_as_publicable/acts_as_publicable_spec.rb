require "spec_helper"

describe "acts_as_publicable" do
    it "raises an error when it's not present published field" do
        lambda { 
            class Post
                acts_as_publicable
            end
        }.should raise_error ActsAsPublicable::FieldNotPresentError
    end

    before(:all) do
        Article.create!(:title=>"first",:published=>true)
        Article.create!(:title=>"second") 
        Article.create!(:title=>"third")
    end

    context "published scope" do

        it "responds to published" do
            Article.should respond_to(:published)
        end

        it "returns the published articles" do
            Article.published.all? {|a| a.published}.should be true
        end

    end

    context "unpublished scope" do

        it "adds unpublished scope" do
            Article.should respond_to(:unpublished)
        end

        it "returns the unpublished articles" do
            Article.unpublished.any? {|a| a.published}.should be false
        end

    end

    context "by_published_state" do

        it "adds by_published_state scope" do
            Article.should respond_to(:by_published_state)
        end

        context "with true as parameter" do

            it "returns the published articles" do
                Article.by_published_state(true).all? {|a| a.published}.should be true
            end
            
        end

        context "with false as parameter" do

            it "returns the unpublished articles" do
                Article.by_published_state(false).any? {|a| a.published}.should be false
            end
            
        end
    end

    describe "#publish!" do
        it "publish an article" do
            @article = Article.create!(:title=>"Awesome article")
            @article.publish!
            @article.should be_published
        end
    end

    describe "#unpublish!" do
        it "unpublish an article" do
            @article = Article.create!(:title=>"Awesome article",:published => true)
            @article.unpublish!
            @article.should_not be_published
        end
    end

end
