class AddOrderTestData < ActiveRecord::Migration
  def self.up
    Order.delete_all
    Order.create(:name => 'Jo Blow', :address => '123 Jump St.',
      :email => 'jo@blow.com', :pay_type => 'check')
  end

  def self.down
    Order.delete_all
  end
end
