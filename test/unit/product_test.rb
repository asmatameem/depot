require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products
  def new_product(image_url)
    Product.new({:title => "any title", :description => "any desc", :price => 1, :image_url => image_url})
  end

  test "Product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test "Product price must be positive number" do
    product = Product.new({:title => "any title", :description => "random desc", :image_url => "image.jpg"})

    product.price = -1
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

    product.price = 1
    assert product.valid?
  end

  test "image_url" do
    ok = %w{ fred.gif fred.jpg fred.png http://abc.com/image.jpg }
    bad = %w{ fred.doc fred.ppt fred.gif/more }

    ok.each do |name|
      assert new_product(name).valid?, "#{name} should not be invalid"
    end

    bad.each do |name|
      assert new_product(name).invalid?, "#{name} should not be valid"
    end
  end

  test "product is not valid without a unique title" do
    product = Product.new({:title => products(:ruby).title, :description => "yyy", :price => 1, :image_url => "fred.gif"})

    assert product.invalid?
    assert_equal [I18n.translate('activerecord.errors.messages.taken')], product.errors[:title]
  end


end
