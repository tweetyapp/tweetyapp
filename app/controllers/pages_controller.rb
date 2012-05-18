class PagesController < ApplicationController
  def home
      @title = "Home"
  end

  def contact
    @title = "Contact"
  end
  
  def index
  end
  
  def about
    @title = "About"
  end
end
