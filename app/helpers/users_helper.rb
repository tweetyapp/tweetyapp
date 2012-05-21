module UsersHelper
	def gravatar_img(user, options = {:size => 50})

		gravatar_image_tag(user.email.downcase, :alt => user.name, :class => "gravatar",:gravatar =>options)
	end
end
