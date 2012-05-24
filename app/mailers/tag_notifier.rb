class TagNotifier < ActionMailer::Base
  default :from => "from@example.com",
  :return_path => 'system@example.com'

  def send_notification(user,url)
  	@user= user
  	@url = "http://localhost:3000/users/#{url}"
  	mail(:from => "no-reply@tweety.com",:to => user.email, :subject => "You are mentioned in a tweet!!!!!")
  end
end
