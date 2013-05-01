class Book < ActiveRecord::Base
  belongs_to :category

  validates_presence_of :isbn, :title, :price, :category_id
  validates_numericality_of :price, allow_blank: true
end
