class PageSerializer < ActiveModel::Serializer
  attributes :full_url
  has_many :assets
end
