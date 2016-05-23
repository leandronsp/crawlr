class AddDomainReferenceToPage < ActiveRecord::Migration
  def change
    add_reference :pages, :domain, index: true, foreign_key: true
  end
end
