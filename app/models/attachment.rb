class Attachment < ApplicationRecord
  belongs_to :user
  has_many :public_links, dependent: :destroy

  def key
    public_links.order(created_at: :desc).first&.key
  end
end
