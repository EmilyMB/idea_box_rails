class User < ActiveRecord::Base
  has_secure_password

  has_many :ideas

  enum role: ["default", "admin"]
end
