module ActiveApplication
  class User < ActiveRecord::Base
    attr_accessible :email, :password, :password_confirmation, :remember_me

    devise :database_authenticatable, :registerable, :confirmable,
      :recoverable, :rememberable, :trackable, :validatable

    def to_s
      email
    end
  end
end
