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
		@s = ShoppingCart.new(0.1, 0.05)
		@cd = Product.new("music CD", 14.99, false, false)
		@importedChoc = Product.new("imported box of chocolates", 10.00, true, true)
		@imported_perfume = Product.new("imported bottle of perfume", 27.99, false, true)
		@perfume = Product.new("bottle of perfume", 18.99, false, false)
		@pills = Product.new("packet of headache pills", 9.75, true, false)
		@imported_choc = Product.new("imported box of chocolates", 11.25, true, true)
	end

	it 'should create an empty shopping cart successfully' do
		@s.getTotal.should == 0
	end

	it 'can add a product to the shopping cart' do
		@s.add(@cd)
		@s.getTotalTax.should == 1.50
	end

	it 'can add more than one product to the shopping cart' do
		@s.add(@cd)
		@s.add(@importedChoc)
		@s.getTotalTax.should == 2.0
	end

	it 'can add multiple quantities of one product to the shopping cart' do
		@s.add(@cd, 2)
		@s.add(@cd, 2)
		@s.getTotalTax.should == 6.0
	end

	it 'can print the receipt in the desired format' do
		@cart = ShoppingCart.new(0.1, 0.05)
		@cart.add(@imported_perfume)
		@cart.add(@perfume)
		@cart.add(@pills)
		@cart.add(@imported_choc)

		@cart.printReceipt().should == "1 imported bottle of perfume: 32.19\n1 bottle of perfume: 20.89\n1 packet of headache pills: 9.75\n1 imported box of chocolates: 11.85\nSales Taxes: 6.70\nTotal: 74.68"
	end

end

