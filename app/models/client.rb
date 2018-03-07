class Client < ApplicationRecord
  has_many :locations, dependent: :restrict_with_exception
  has_one :oauth_applications, class_name: 'Doorkeeper::Application', as: :owner, dependent: :restrict_with_exception

  validates :name, uniqueness: true, presence: true
end
