class Domain < ActiveRecord::Base
  has_many :pages
  validates_uniqueness_of :url
end
