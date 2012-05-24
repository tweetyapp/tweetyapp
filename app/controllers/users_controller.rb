class UsersController < ApplicationController

  before_filter :authenticate, :except => [:show,:new,:create,:forgot,:forgotlink,:reset_password,:update_password]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => [:destroy]

  #@@current_user
  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page], :per_page => 15)
  end
  def new
  	@title="Sign up"
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page], :per_page => 10)
  	@title = @user.name
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page], :per_page => 10)
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page], :per_page => 10)
    render 'show_follow'
  end
  def create
  	@user= User.new(params[:user])
  	if @user.save
      @user.update_attribute(:url,@user.id)
  		redirect_to @user, :flash => { :success => "Welcome to the Sample App!"
}
  	else
  		@title = "Sign up"
  		render 'new'
  	end
  end

  def edit
    @user = User.find(params[:id])
    @title = "Edit user"
  end

  def update
    @title = "Update user"
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated successfully"
      redirect_to @user
    else
      @user.url=nil
      render 'edit'
    end
  end

  def destroy
    #raise params.inspect
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_path
  end

  def forgot
    render 'forgot'
  end

  def forgotlink
    #redirect_to root_path
    #code to send mail
    if access_check
      user = User.find_by_email(params[:user][:email])
      if !user.nil? 
        user.reset_code_valid = 1.day.from_now
        user.reset_code =  Digest::SHA2.hexdigest( "#{user.salt}#{Time.now.utc}" )
        user.password = user.password_confirmation = "password"
        user.save!
        Notifier.send_mail(user).deliver
        flash[:notice] = "Reset link sent to #{user.email}"
      else
        flash[:error] = "Invalid email!"
      end 
      redirect_to root_path
    end
    #redirect_to root_path
  end

  def reset_password 
    if params[:reset_code]
      user = User.find_by_reset_code(params[:reset_code])
      @@current_user = user if user && user.reset_code_valid && Time.now < user.reset_code_valid
      unless @@current_user.nil?
        flash[:success]= "Set your new password " + @@current_user.name + " !"
        render 'updatepass', :locals => { :cur_user => @@current_user.email}
      else
        flash[:error]= "Link expired"
        redirect_to root_path
      end
    else
      redirect_to root_path, :flash => { :error => "Cannot access this page!"} 
    end
  end

  def update_password
    #raise params.inspect
    if access_check
      current_user = User.find_by_email(params[:user][:cur_user])
      unless current_user.nil?
        current_user.password = current_user.password_confirmation=params[:user][:password]
        current_user.save!
        flash[:success] = "Password updated successfully! Login again #{current_user.name}" 
        redirect_to signin_path
      else
        flash[:error] = "Sign in to access page"
        redirect_to root_path
      end
    end
  end

  private

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_path, :flash => {:error => "You dont have enough permission to do the requested operation"} unless current_user?(@user)
  end

  def admin_user
    user = User.find(params[:id])
    redirect_to root_path, :flash => { :error => "Cannot delete!You dont have enough permission to do the requested operation!"} if (!current_user.admin?() || current_user?(user))
  end

  def access_check
    if params[:user].nil?
      redirect_to root_path, :flash => { :error => "Cannot access this page!"} 
      return nil
    else
      return true
    end
  end
end


