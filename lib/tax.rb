
=begin
	
Author: Teri Leung
Challenge problem: Sales Taxes
Language: Ruby (version 2.1.2)



Design and Assumptions:
I've designed this problem by creating 3 classes: Product, Tax, and ShoppingCart.
Product has the product description and price.  A product can be imported and/or exempted.
Tax calculates the taxes for a product.  It also has a tax policy to determine which taxes apply.  Basic sales tax and import duty are both taxes.
Shopping cart has products, their taxes, their prices, and also total taxes and total prices.

In designing Product, I've assumed that books, foods and medical items as the same Product, since no information differentiating them exists.
Future recommendation would be to create Books, Foods, and Medical Items as Product subclasses, as more information differentiating them exists.


Instructions on how to run:
1) Take one sales transaction.  Copy the input data, exclude any titles, and paste it into a text file
2) Save this file as "input.txt" and place the file into the Sales folder
3) Run lib/tax.rb
4) Under Sales folder, open the newly created file "output.txt"

=end

class Product
	def initialize(name, price, excluded = false, imported = false)
		@name = name
		@price = price
		@excluded = excluded
		@imported = imported
	end

	def getName()
		@name
	end

	def getPrice()
		@price
	end

	def isExempt?()
		@excluded
	end

	def isImport?()
		@imported
	end
end

class Tax
	def initialize(rate={})
		@rate = rate
		@basic = @rate[:basic]
		@import = @rate[:import]
	end

	def calculateTax(item)
		if @rate.has_key?(:basic)
			if item.isExempt?()
				0
			else
				(item.getPrice() * @basic).round(2)
			end
		elsif @rate.has_key?(:import)
			if item.isImport?()
				(item.getPrice() * @import).round(2)
			else
				0
			end
		end
	end
end

class BasicTax < Tax
	def initialize(rate)
		super(:basic => rate)
	end
end

class ImportDuty < Tax
	def initialize(rate)
		super(:import => rate)
	end
end

class Float
	def rounding()
		(self*20).ceil/20.0
	end
end

class ShoppingCart
	def initialize(basicRate, importRate)
		@total_tax = 0
		@total = 0
		@tax_sales = BasicTax.new(basicRate)
		@tax_duty = ImportDuty.new(importRate)
		@product_list = []
	end

	def add(item, count=1)
		@tax = (1.0*(@tax_sales.calculateTax(item) + @tax_duty.calculateTax(item))*count).rounding()
		@total_tax = @total_tax + @tax

		@item_with_tax = item.getPrice()*count + @tax
		@total = @total + @item_with_tax

		@string = count.to_s + " " + item.getName() + ": " + ('%.2f' % @item_with_tax).to_s
		@product_list << @string
	end

	def getTotalTax()
		@total_tax
	end

	def getTotal()
		@total
	end

	def printReceipt()
		@product_list << ("Sales Taxes: " + ('%.2f' % @total_tax).to_s)
		@product_list << ("Total: " + ('%.2f' % @total).to_s)
		@product_list.join("\n")
	end
end


#Main Application

keywords = []

f = File.open("keywords.txt", "r")
f.each_line do |line|
	keywords << line.chomp
end
f.close

cart = ShoppingCart.new(0.1, 0.05)

f = File.open("input.txt", "r")
f.each_line do |line|
	price = (line.split(" at "))[1].to_f
	quantity = (line[0].split())[0].to_i
	name = (line.split(" at "))[0].gsub(/[0-9]/,"").strip
	import = line.include?("imported")
	exempt = keywords.any? {|word| line.include?(word)}

	item = Product.new(name, price, exempt, import)
	cart.add(item, quantity)
end
f.close

f = File.open("output.txt", "w")
f.write(cart.printReceipt())
f.close


