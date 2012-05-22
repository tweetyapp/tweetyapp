class UsersController < ApplicationController

  before_filter :authenticate, :only => [:edit, :update,:show]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => [:destroy]

  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end
  def new
  	@title="Sign up"
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
  	@title = @user.name
  end

  def create
  	@user= User.new(params[:user])
  	if @user.save
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
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_path
  end

  private

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_path unless current_user?(@user)
  end

  def admin_user
    user = User.find(params[:id])
    redirect_to root_path, :flash => { :error => "Cannot delete!You dont have enough permission to do the requested operation!"} if (!current_user.admin?() || current_user?(user))
 end
end

