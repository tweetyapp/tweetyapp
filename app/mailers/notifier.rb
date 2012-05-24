class Notifier < ActionMailer::Base
  default :from => "no-reply@tweety.com",
  :return_path => 'system@example.com'

  def send_mail(user)
  	@user= user
  	@url = "http://localhost:3000/reset_password/#{user.reset_code}"
  	mail(:from => "no-reply@tweety.com",:to => user.email, :subject => "Password reset")
  end
end
