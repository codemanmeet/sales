
=begin
	
Author: Teri Leung
	
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

cart = ShoppingCart.new(0.1, 0.05)
getInput = true

while (getInput)

	puts "Product description?"

	name = gets.chomp

	#puts "name is #{name}"

	puts "How many?"

	quantity = gets.to_i

	#puts "quantity is #{quantity}"

	puts "Price per unit?"

	price = gets.to_f

	#puts "price is #{price}"

	puts "Is it a book, food or medical item? (y/n)"

	e = gets.chomp

	if e == "Y" or e == "y" 
		exempt = true
	elsif e == "N" or e == "n"
		exempt = false
	else
		puts "error"
	end

	puts "Is it imported?"

	i = gets.chomp

	if i == "Y" or i == "y" 
		import = true
	elsif i == "N" or i == "n"
		import = false
	else
		puts "error"
	end

	item = Product.new(name, price, exempt, import)

	cart.add(item, quantity)

	puts "Add another item to the shopping cart? (y/n)"

	again = gets.chomp

	if (again == "Y" or again == "y")
		getInput = true
	elsif (again == "N" or again == "n")
		getInput = false
	else
		puts "error"
	end
end

puts "-----Receipt-----"
puts cart.printReceipt()

