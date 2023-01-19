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
