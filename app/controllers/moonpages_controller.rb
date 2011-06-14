class MoonpagesController < ApplicationController
  def home
    @title = "Home"
	if signed_in?
      @ad = Ad.new
      @feed_items = current_user.feed.paginate(:page => params[:page], :per_page => 3)
    end
	#@ad = Ad.new if signed_in?
  end

  def contact
    @title = "Contact"
  end

  def about
    @title = "About"
  end
  
  def help
    @title = "Help"
  end
end
