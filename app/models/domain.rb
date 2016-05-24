class Domain < ActiveRecord::Base
  has_many :pages
  has_many :assets

  validates_uniqueness_of :url

  before_create :create_root_page

  def root_page
    pages.where(url: '/').first
  end

  def reset!
    destroy_assets = "DELETE FROM assets WHERE domain_id = #{self.id}"
    destroy_pages  = "DELETE FROM pages WHERE domain_id = #{self.id}"

    ActiveRecord::Base.connection.execute destroy_assets
    ActiveRecord::Base.connection.execute destroy_pages
    create_root_page
    save!
  end

  private

  def create_root_page
    self.pages << Page.new(url: '/')
  end
end
