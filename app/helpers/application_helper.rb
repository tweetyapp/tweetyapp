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
end
