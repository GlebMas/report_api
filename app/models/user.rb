class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :username, presence: true, uniqueness: true

  def token_expired?
    unless token_created.nil?
      (Time.now - token_created) / 3600 > 12
    end
  end

  def generate_api_key
    self.update_column(:api_key, SecureRandom.hex(16))
  end
end
