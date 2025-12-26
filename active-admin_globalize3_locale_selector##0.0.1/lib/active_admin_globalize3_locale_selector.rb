# encoding: utf-8
require 'active_admin/globalize3_locale_selector/dsl'
require 'active_admin/globalize3_locale_selector/engine'
::ActiveAdmin::DSL.send(:include, ActiveAdmin::Globalize3LocaleSelector::DSL)