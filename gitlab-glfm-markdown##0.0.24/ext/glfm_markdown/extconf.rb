# frozen_string_literal: true

require 'mkmf'
require 'rb_sys/mkmf'

create_rust_makefile('glfm_markdown/glfm_markdown') do |r|
  r.auto_install_rust_toolchain = false
end
