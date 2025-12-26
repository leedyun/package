%w(
    version
    primer_design
    l1_result_page
    l2_result_page
  ).each { |file| require File.join(File.dirname(__FILE__), 'bisearch_enzim_hu', file) }


module BisearchEnzimHu
  # Your code goes here...
end
