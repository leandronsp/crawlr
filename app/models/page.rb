class Page < ActiveRecord::Base
  belongs_to :domain
  has_many :assets

  validates_presence_of :url, :domain
end
