class PublicLink < ApplicationRecord
  belongs_to :attachment

  VALID_FOR = 1.day

  before_save :add_expire_at

  private
  def add_expire_at
    self.created_at = Time.zone.now + VALID_FOR
  end
end
