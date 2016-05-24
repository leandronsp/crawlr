class PageSerializer < ActiveModel::Serializer
  attributes :id
  attributes :full_url
  attributes :url
  attributes :title

  has_many :assets
end
