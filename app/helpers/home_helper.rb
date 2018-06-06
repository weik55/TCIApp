module HomeHelper
	def gen_stars (n = 0)
		r = 5 - n
		stars = ''
		n.times do
			stars += '<i class="stars-gold fas fa-star"></i>'
		end

		r.times do
			stars += '<i class="stars-grey fas fa-star"></i>'
		end
		return stars
	end
end
