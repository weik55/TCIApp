
# A simple class to keep our API keys hidden from repositories
# A better way to do this is to use enviroment keys for actual production
class Keys

	def Keys.mdb_api
		API
	end

	private
		API = "fe6f1f7f211065dc50201f2985280755"
end