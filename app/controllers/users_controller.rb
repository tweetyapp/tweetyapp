class UsersController < ApplicationController

  before_filter :authenticate, :only => [:edit, :update,:show]

  def new
  	@title="Sign up"
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
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

  private

  def authenticate
    deny_access unless signed_in?
  end
end

