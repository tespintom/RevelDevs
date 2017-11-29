class PotatoController < ActionController::Base
  protect_from_forgery with: :exception

  def great_method
    puts "potato"
  end

  def even_greater_method
    puts "potatoes"
  end
  
end
