class EntryLog < ApplicationRecord
  belongs_to :user

  validates :entry_time, presence: true
end
