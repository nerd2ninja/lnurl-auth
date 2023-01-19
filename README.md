# lnurl-auth
Instructions for implementing lnurl-auth in rails.

Here's an example of how you might implement LNURL-auth in a Rails server:

First, you'll need to add a route to handle the callback request from the user's wallet.

Copy code
#config/routes.rb
post '/lnurl-auth/callback', to: 'lnurl_auth#callback'
Then, you'll need to create a controller to handle the callback request and authenticate the user.

Copy code
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
In this example, the authenticate_lnurl_auth and login_lnurl_auth methods should be implemented in your user model. These methods should verify the authenticity of the request and log the user in if the request is valid.

Finally, you will need to create an endpoint on your server that will generate the LNURL and return it to the client.

Copy code
#app/controllers/users_controller.rb
class UsersController < ApplicationController
  def login
    user = User.new
    user.lnurl_auth_k1 = SecureRandom.hex
    user.save
    lnurl = "lnurl1auth+https://yourserver.com/lnurl-auth/callback?k1=#{user.lnurl_auth_k1}&tag=login"
    render json: {lnurl: lnurl}
  end
end
Keep in mind that this is just an example and you will need to adapt it to fit your specific use case. You will also need to take care of the security and validate
