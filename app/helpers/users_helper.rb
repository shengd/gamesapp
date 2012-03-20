module UsersHelper
  # Returns a Gravatar (http://gravatar.com) based on the user's email
  def gravatar_for(user)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "http://gravatar.com/avatar/#{gravatar_id}.png"
    image_tag(gravatar_url, alt: user.login, class: "gravatar")
  end
end
