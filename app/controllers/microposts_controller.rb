class MicropostsController < ApplicationController
	before_filter :authenticate
	before_filter :authorized_user, :only => :destroy

	def create
		@micropost = current_user.microposts.build(params[:micropost])
		if @micropost.save
			redirect_to root_path, :flash => {:success => "Your tweet posted sucessfully!"}
		else
			@feed_items = current_user.feed.paginate(:page => params[:page], :per_page => 10)
			render 'pages/home'	
		end
	end

	def destroy
		@micropost.destroy
		redirect_to root_path, :flash => { :notice => "Tweet deleted!"}
	end

	private
		def authorized_user
			@micropost = Micropost.find(params[:id])
			redirect_to root_path unless current_user?(@micropost.user)
		end
end