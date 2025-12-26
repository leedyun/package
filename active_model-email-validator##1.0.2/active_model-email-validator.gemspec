Gem::Specification.new do |s|
s.name = 'active_model-email-validator'
  s.version  = '1.0.2'
  s.summary  = 'An ActiveModel email validator based on the Mail gem.'
  s.homepage = 'http://codyrobbins.com/software/active-model-email-validator'
  s.author   = 'Cody Robbins'
  s.email    = 'cody@codyrobbins.com'

  s.post_install_message = '
-------------------------------------------------------------
Follow me on Twitter! http://twitter.com/codyrobbins
-------------------------------------------------------------

'

  s.files =Dir['**/*'].keep_if { |file| File.file?(file) }

  s.add_dependency('activemodel')
  s.add_dependency('mail')
s.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]end