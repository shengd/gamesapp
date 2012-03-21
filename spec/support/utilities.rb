def full_title(page_title = '')
  base_title = "Gamesapp"
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end

def sign_in(user)
  visit login_path
  fill_in "Username", with: user.login
  fill_in "Password", with: user.password
  click_button "Login"
  cookies[:remember_token] = user.remember_token
end

def sign_in_by_email(user)
  visit login_path
  fill_in "Username", with: user.email
  fill_in "Password", with: user.password
  click_button "Login"
  cookies[:remember_token] = user.remember_token
end
