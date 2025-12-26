Given /^I have an assembly pom\.xml$/ do
  maven = Maven.new "testdata/assembly_pom.xml"
  maven.ops[:artifact_type].should == "assembly"
end

Given /^that the assembly jar is built$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should return the name of the assembly jar$/ do
  pending # express the regexp above with the code you wish you had
end

#------------------------------------------------------

When /^I ask for the artifact name$/ do
  # @maven.ops[:artifact_name].should == "abc"
end

Then /^I should get the name of the artifact$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^I have an "([^"]*)"$/ do |arg1|
  @maven.ops[:deploy_artifact_type].should == "assembly"
end

Given /^its artifact "([^"]*)" is built$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then /^I should return the name of the "([^"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

