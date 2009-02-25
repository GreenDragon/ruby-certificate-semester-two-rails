class DevelopmentTestData < ActiveRecord::Migration
  def self.up
    Location.delete_all
    Group.delete_all

    Group.create(
      :id => 1, 
      :name => "Seattle Ruby Brigade", 
      :alias => "Seattle.rb",
      :url => "http://www.zenspider.com/Languages/Ruby/Seattle/"
    )
    
    Group.create(
      :id => 2, 
      :name => "The Portland Ruby Brigade", 
      :alias => "PDX.rb",
      :url => "http://pdxruby.org/"
    )
    
    Group.create(
      :id => 3, 
      :name => "Vancouver Ruby Brigade", 
      :alias => "Vancouver.rb",
      :url => "http://groups.google.com/group/vanrb"
    )
    
    Group.create(
      :id => 4, 
      :name => "Calgary Ruby Users Society", 
      :alias => "CRUserS",
      :url => "http://tech.groups.yahoo.com/group/crusers/"
    )

    Group.create(
      :id => 5,
      :name => "Chicago Area Ruby Group",
      :alias => "chirb",
      :url => "http://chirb.org/"
    )

    Location.create(
      :name => "Vivace Espresso Bar at Brix",
      :address => "532 Broadway Ave. East, Seattle, WA, USA",
      :latitude => "",
      :longitude => "",
      :group_id => 1
    )

    Location.create(
      :name => "CubeSpace",
      :address => "622 SE Grand Ave., Portland, OR, USA",
      :latitude => "",
      :longitude => "",
      :group_id => 2
    )

    # BC, CA
    Location.create(
      :name => "Waves Coffee",
      :address => "492 Hastings Street West, Vancouver, British Columbia, CA",
      :latitude => "",
      :longitude => "",
      :group_id => 3
    )

    # AB, CA
    Location.create(
      :name => "Flamingo Block Building", 
      :address => "229 11 Avenue SE, Suite 350, Calgary, Alberta, CA",
      :latitude => "",
      :longitude => "",
      :group_id => 4
    )

    Location.create(
      :name => "ThoughtWorks Aon Center",
      :address => "200 E. Randolph, 25th Floor, Chicago, IL, USA",
      :latitude => "",
      :longitude => "",
      :group_id => 5
    )

  end

  def self.down
    Location.delete_all
    Group.delete_all
  end
end
