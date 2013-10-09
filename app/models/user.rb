# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
          :rememberable, :omniauthable
  attr_accessible :login,
                  :password,
                  :password_confirmation,
                  :remember_me,
                  :provider,
                  :uid
  # Relations
  # ===========================================================                 
  has_many :posts, dependent: :destroy

  # Validation
  # ===========================================================
  validates :login, presence: true, uniqueness: true

  class << self
    def find_for_provider_oauth(auth, signed_in_resource=nil)
      user = User.where(:provider => auth.provider, :uid => auth.uid).first
      unless user
        case auth.provider
          when "vkontakte"
            params  = { login:auth.extra.raw_info.domain,
                        provider:auth.provider,
                        uid:auth.uid,
                        password:Devise.friendly_token[0,20]
                        }
          when "twitter"
            params  = { login:auth.info.nickname,
                        provider:auth.provider,
                        uid:auth.uid,
                        password:Devise.friendly_token[0,20]
            }
        end
        user = User.new(params)
        user.save
      end
      user
    end

    def find_first_by_auth_conditions(warden_conditions)
      conditions = warden_conditions.dup
      where(conditions).where("lower(login) = ?", login.downcase).first
    end

  end
end
