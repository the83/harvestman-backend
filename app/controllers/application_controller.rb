# class ApplicationController < ActionController::Base
#   # Prevent CSRF attacks by raising an exception.
#   # For APIs, you may want to use :null_session instead.
#   protect_from_forgery with: :null_session
#   after_filter :set_csrf_cookie

#   def set_csrf_cookie
#     cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
#   end

# protected

#   # In Rails 4.2 and above
#   def verified_request?
#     super || valid_authenticity_token?(session, request.headers['X-XSRF-TOKEN'])
#   end

#   def authenticate_user_from_token!
#     authenticated = authenticate_with_http_token do |user_token, options|
#         user_email = options[:user_email].presence
#         user       = user_email && User.find_by_email(user_email)

#         if user && Devise.secure_compare(user.authentication_token, user_token)
#           sign_in user, store: false
#         else
#           render json: 'Invalid authorization.'
#         end
#       end

#     if !authenticated
#       render json: 'No authorization provided.'
#     end
#   end
# end
#
class ApplicationController < ActionController::Base
  before_filter :authenticate_user_from_token!

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery
  after_filter :set_csrf_cookie

  def set_csrf_cookie
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  private

    def authenticate_user_from_token!
      authenticate_with_http_token do |token, options|
      user_email = options[:user_email].presence
      user       = user_email && User.find_by_email(user_email)

      if user && Devise.secure_compare(user.authentication_token, token)
        sign_in user, store: false
      end
    end
  end
end
