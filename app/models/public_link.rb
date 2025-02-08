class PublicLink < ApplicationRecord
  belongs_to :attachment

  VALID_FOR = 1.day

  before_save :add_expire_at

  scope :valid_links, -> {where(expire_at: [Time.now...])}

  private
  def add_expire_at
    self.expire_at = Time.zone.now + VALID_FOR
  end
end
