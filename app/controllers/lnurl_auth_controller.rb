#app/controllers/lnurl_auth_controller.rb
class LnurlAuthController < ApplicationController
  def callback
    k1 = params[:k1]
    tag = params[:tag]
    pr = params[:pr]

    # Retrieve the user associated with the given k1
    user = User.find_by(lnurl_auth_k1: k1)

    if user.nil?
      # Handle the error if the user is not found
      render json: {status: 'FAIL', statusMessage: 'User not found'}, status: :unauthorized
    else
      # Verify the authenticity of the request
      if tag == "auth"
          if user.authenticate_lnurl_auth(pr)
            # User is authenticated, log them in and return success
            sign_in(user)
            render json: {status: 'OK', statusMessage: 'User authenticated'}, status: :ok
          else
            # Handle the error if the authentication fails
            render json: {status: 'FAIL', statusMessage: 'Authentication failed'}, status: :unauthorized
          end
      elsif tag == "login"
          if user.login_lnurl_auth(pr)
            # User is authenticated, log them in and return success
            sign_in(user)
            render json: {status: 'OK', statusMessage: 'User logged in'}, status: :ok
          else
            # Handle the error if the login fails
            render json: {status: 'FAIL', statusMessage: 'Login failed'}, status: :unauthorized
          end
      else
        # Handle the error if the tag is not recognized
        render json: {status: 'FAIL', statusMessage: 'Invalid tag'}, status: :unauthorized
      end
    end
  end
end
