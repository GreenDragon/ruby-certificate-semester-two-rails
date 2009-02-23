require 'test_helper'
require 'nokogiri'
require 'json'

class InfoControllerTest < ActionController::TestCase
  fixtures :all
  test "default get returns html" do
    get :who_bought, :id => products(:git_book).id

    assert_response :success
    assert_tag :tag => "title", :content => /Books/
  end

  test "requesting xml format returns xml" do
    get :who_bought, :id => products(:git_book).id, :format => "xml"

    content = Nokogiri::XML(@response.body)
    assert_response :success
    assert_equal content.xpath('/product/title').inner_text, 
                  products(:git_book).title
  end

  test "requesting json format returns json" do
    get :who_bought, :id => products(:git_book).id, :format => "json"

    content = ActiveSupport::JSON(@response.body)
    assert_response :success
    assert_equal products(:git_book).title, content['product']['title']
  end

  test "requesting atom format returns atom" do
    get :who_bought, :id => products(:git_book).id, :format => "atom"

    assert_response :success
    assert_tag :tag => 'title', :content => "Who bought #{products(:git_book).title}"
    assert_tag :tag => 'name', :content => orders(:one).name
    assert_tag :tag => 'email', :content => orders(:one).email
  end
end
