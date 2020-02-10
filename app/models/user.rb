class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :password, length: { minimum: 6 }
  validates :name, presence: true, length: { minimum: 2, maximum: 50 }

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :friendships
  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id'

  def friends
    return friendships_confirmed + inverse_friendships_confirmed
  end

  def friendships_pending
    friendships_pending = []
    friendships.where(confirmed: false).each { |fs| friendships_pending << User.find(fs.friend_id) }
    friendships_pending
  end

  def inverse_friendships_pending
    inverse_friendships_pending = []
    inverse_friendships.where(confirmed: false).each { |fs| inverse_friendships_pending << User.find(fs.user_id) }
    inverse_friendships_pending
  end

  def friendships_confirmed
    friendships_confirmed = []
    friendships.where(confirmed:true).each { |fs| friendships_confirmed << User.find(fs.friend_id) }
    friendships_confirmed
  end

  def inverse_friendships_confirmed
    inverse_friendships_confirmed = []
    inverse_friendships.where(confirmed: true).each { |fs| inverse_friendships_confirmed << User.find(fs.user_id) }
    inverse_friendships_confirmed
  end
end
