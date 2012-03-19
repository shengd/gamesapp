module ApplicationHelper
  # Returns the title on a per-page basis
  def get_title(page_title)
    title = "Gamesapp"
    return title if page_title.empty?
    "#{title} | #{page_title}"
  end
end
