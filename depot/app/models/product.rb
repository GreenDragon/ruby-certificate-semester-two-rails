class Product < ActiveRecord::Base

  has_many                  :line_items

  validates_presence_of     :title, :description, :image_url
  validates_numericality_of :price
  validate                  :price_must_be_at_least_one_cent
  validates_uniqueness_of   :title
  validates_format_of       :image_url,
                            :with => %r{\.(gif|jpg|png)$}i,
                            :message => 'must be a URL for GIF, JPG ' +
                                        'or PNG image.'

  def self.find_products_for_sale
    find(:all, :order => "title")
  end

protected

  def price_must_be_at_least_one_cent
    errors.add(:price, 'should be at least 0.01') if price.nil? ||
                                                     price < 0.01
  end

end
