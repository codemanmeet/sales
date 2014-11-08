class Product
	def initialize(name, price, excluded = false, imported = false)
		@name = name
		@price = price
		@excluded = excluded
		@imported = imported
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
			(item.getPrice() * @import).round(2)
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

class ShoppingCart
end