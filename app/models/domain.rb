class Domain < ActiveRecord::Base
  has_many :pages
  validates_uniqueness_of :url

  before_create :create_root_page

  def root_page
    pages.where(url: '/').first
  end

  private

  def create_root_page
    self.pages << Page.new(url: '/')
  end
end
