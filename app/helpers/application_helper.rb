module ApplicationHelper

  # title for page
  
  def title
    base_title ="RoR Tutorials Sample App"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  def logo
  	image_tag("final_logo.jpeg", :alt => "Sample App", :class => "round", :options => {:size => 50})
  end
end
