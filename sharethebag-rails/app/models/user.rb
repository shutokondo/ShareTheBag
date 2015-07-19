class User < ActiveRecord::Base
  authenticates_with_sorcery!
  has_many :items

  before_create :generate_access_token

  scope :by_auth_token, ->(auth_token) { find_by(auth_token: auth_token)}

  #carrierWaveでの記述
  mount_uploader :bagImage, ImageUploader
  mount_uploader :avatar, ImageUploader

  acts_as_followable

  acts_as_follower

  private
    def generate_access_token
      begin
        self.auth_token = SecureRandom.hex
      end while self.class.exists?(auth_token: auth_token)
    end
end
