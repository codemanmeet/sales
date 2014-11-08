require 'tax'

describe Product do
	it 'should create a new product' do
		@p = Product.new("music CD", 14.99, false, false)
	end
end

describe Tax do

	before do 
		@cd = Product.new("music CD", 14.99, false, false)
		@book = Product.new("book", 12.49, true, false)
		@importedChoc = Product.new("imported box of chocolates", 10.00, true, true)
	end

	it 'should calculate the tax correctly' do
		Tax.new(:basic => 0.1).calculateTax(@cd).should == 1.50
	end

	it 'should calculate the tax correctly for an exempted item' do
		Tax.new(:basic => 0.1).calculateTax(@book).should == 0
	end

	it 'should calculate the tax for an imported item correctly' do
		Tax.new(:import => 0.05).calculateTax(@importedChoc).should == 0.50
	end

	describe "tax subclasses" do
		describe "BasicTax subclass" do
			it "is constructed with a basic tax rate" do 
				BasicTax.new(0.1).calculateTax(@cd).should == 1.50
			end

			it "is a Tax subclass" do
				BasicTax.new(0).should be_a(Tax)
			end
		end

		describe "ImportDuty subclass" do
			it "is constructed with a import tax rate" do
				ImportDuty.new(0.05).calculateTax(@importedChoc).should == 0.50
			end

			it "is a Tax subclass" do
				ImportDuty.new(0).should be_a(Tax)
			end
		end
	end

end

describe ShoppingCart do

	before do
		@s = ShoppingCart.new
	end

end

