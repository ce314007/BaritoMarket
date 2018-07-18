class AppGroupUser < ApplicationRecord
  belongs_to :app_group
  belongs_to :user
  belongs_to :role

  validates :app_group_id, uniqueness: { scope: [:user_id, :role_id] }
end
