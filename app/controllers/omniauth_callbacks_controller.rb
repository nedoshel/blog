# -*- coding: utf-8 -*- 
class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def vkontakte
    process_callback
  end

  def twitter
    process_callback
  end


  def process_callback
    @user = User.find_for_provider_oauth(request.env["omniauth.auth"], current_user)
    if @user.persisted?
      flash[:notice] = I18n.t "msg.omniauth_callbacks_success"
      sign_in @user, event: :authentication
      redirect_to root_path
    else
      session["devise.#{request.env["omniauth.auth"].provider}_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

end