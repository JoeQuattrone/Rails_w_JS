class User < ApplicationRecord
  has_secure_password

  has_many :hotels, through: :visits
  has_many :visits

  validates :first_name, presence: true, format: { without: /[0-9]/, message: "does not allow numbers"}
  validates :last_name, presence: true, format: { without: /[0-9]/, message: "does not allow numbers"}
  validates :email, uniqueness: true, presence: true

end
