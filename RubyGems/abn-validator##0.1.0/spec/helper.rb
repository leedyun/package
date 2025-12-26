require 'abn_validator'

INVALID_ABNS = [
  'AB CDE FGH JKI',
  '11 111 111 111',
  '53 004 085 615'
]

VALID_ABNS = [
  '53 004 085 616',
  '34000908716'
]

class TestBusiness

  include ActiveModel::Validations
  attr_accessor :abn
  validates :abn, abn: true

end
