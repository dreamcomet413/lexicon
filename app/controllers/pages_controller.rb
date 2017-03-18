class PagesController < ApplicationController
  http_basic_authenticate_with name: "safe", password: "qwerty!@"
  
  def home
    
  end
end
