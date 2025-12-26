require "spec_helper"

describe AppliedCSS do
  
  before(:each) do
    FakeWeb.register_uri(:get, "http://local.test.net/sample.html", :body => open(File.expand_path(File.dirname(__FILE__) + '/../samples/sample.html')).read, :content_type => "text/html")
    FakeWeb.register_uri(:get, "http://local.test.net/css/sample1.css", :body => open(File.expand_path(File.dirname(__FILE__) + '/../samples/sample1.css')).read, :content_type => "text/css")
    FakeWeb.register_uri(:get, "http://local.test.net/css/sample2.css", :body => open(File.expand_path(File.dirname(__FILE__) + '/../samples/sample2.css')).read, :content_type => "text/css")
    FakeWeb.register_uri(:get, "http://local.test.net/css/imported.css", :body => open(File.expand_path(File.dirname(__FILE__) + '/../samples/imported.css')).read, :content_type => "text/css")    
  end

  before(:each) do
    path = File.expand_path(File.dirname(__FILE__) + '/..')
    @sample_html = [path, "samples/sample.html"].join("/")
    @sample_html = "http://local.test.net/sample.html"
  end

  # describe "with bbc homepage" do
  #   before(:each) do
  #     @applied_css = AppliedCSS.new("http://www.bbc.co.uk/")
  #   end
  #   
  #   it "should load successfully" do
  #     @applied_css.css("html").should be_an_instance_of Hash
  #   end
  #   it "should determine css declarations" do
  #     @applied_css.css("#blq-container").should == {
  #       
  #       :position => "relative",
  #       :"padding-bottom" => "10px",
  #       :background => "url(../img/body_bg.gif) center repeat-y",
  #     }
  #     
  #   end
  #   describe "with ancestors" do
  #     before(:each) do
  #       @applied_css = AppliedCSS.new("http://www.bbc.co.uk/", :ancestors => true)
  #     end
  #     
  #     it "should load successfully" do
  #       @applied_css.css("html").should be_an_instance_of Hash
  #     end
  #     it "should determine css declarations" do
  #       @applied_css.css("#blq-container").should == {
  #         
  #         :position => "relative",
  #         :"padding-bottom" => "10px",
  #         :padding => "0",
  #         :"font-size" => "62.5%",
  #         :background => "url(../img/body_bg.gif) center repeat-y",
  #         :"font-family" => "verdana,helvetica,arial,sans-serif",
  #         :color => "#111",
  #         :margin => "0",
  #         :"line-height" => "1"
  #       }
  #       
  #     end
  #   end
  # end
  
  describe "with default css" do
    before(:each) do
      @applied_css = AppliedCSS.new(:url => @sample_html)
    end
    
    describe "methods" do
      it "should be an AppliedCSS class" do
        @applied_css.should be_an_instance_of AppliedCSS
      end
      it "should parse the html" do
        @applied_css.doc.should_not be_nil
      end
      it "should return a valid nokogiri document" do
        @applied_css.doc.should be_an_instance_of Nokogiri::HTML::Document
      end
      it "should return a hash for the css method" do
        @applied_css.css("#container").should be_an_instance_of Hash
      end
    end
    
    describe "load ordering" do
      it "should overwrite earlier declarations" do
        @applied_css.css("#container")["height"].should == "600px"
      end
    
      it "should not take settings from ancestors" do
        @applied_css.css("#container")["font-size"].should be_nil
      end
    
      describe "with ancestors" do
        before(:each) do
          @applied_css = AppliedCSS.new(:url => @sample_html, :ancestors => true)
        end
        it "should take settings from ancestors" do
          @applied_css.css("#container")["font-size"].should == "20px"
        end
      end
    end

    describe "using ids" do 
      it "should find declarations using ids" do
        @applied_css.css("#container")["width"].should == "900px"
      end
    end

    describe "using classes" do
      it "should find declarations using classes" do
        @applied_css.css("#container > span").keys.should include "color"
        @applied_css.css("#container > span")["color"].should == "#ff0000"
      end
    end
    
    describe "for imported stylesheets using @import" do
      it "should find declarations delared on imported stylesheets" do
        @applied_css.css("#from-imported").keys.should include "color"
        @applied_css.css("#from-imported")["color"].should == "green"
      end
    end
    
  end
end 
