class Feature < ApplicationRecord
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :product
  # 🚅 add belongs_to associations above.

  has_many :strengths, dependent: :destroy
  has_many :weaknesses, dependent: :destroy
  # 🚅 add has_many associations above.

  has_one :team, through: :product
  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :name, presence: true
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  # 🚅 add methods above.
end
