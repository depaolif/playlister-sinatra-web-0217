module Slug
	module InstanceMethods
		def slug
			self.name.downcase.gsub(/\ /, "-")
		end
		
	end

	module ClassMethods
		def unslug(slug)
			no_cap = ["and","or","the","to","a", "with"]
			slug.gsub(/\-/," ").split(' ').map {|word|
				if no_cap.include?(word)
					word
				else
					word.capitalize
				end
			}.join(" ")
		end

		def find_by_slug(slug)
			find_by(name: unslug(slug))
		end
	end
end