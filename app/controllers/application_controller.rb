class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  def page_not_found
    respond_to do |format|
      format.html{render template: 'errors/not_found_error', layout: 'layouts/application', status: 404}
    end
    
  end
end