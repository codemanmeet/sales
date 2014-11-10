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