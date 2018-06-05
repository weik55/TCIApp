module HomeHelper
	def gen_stars
		stars = ''
		for n in 1..5 do
			stars += '<i class="stars fas fa-star"></i> '
		end
		return stars
	end
end
