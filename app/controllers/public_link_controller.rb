class PublicLinkController < ApplicationController
  include AttachmentConcern
  def generate_public_link
    binding.pry
    key = nil
    loop do
      key = SecureRandom.hex(16)
      break unless PublicLink.exists?(key:, expire_at: [Time.now...])
    end

    public_link = PublicLink.create(key:, attachment: @attachment)
    render "attachments/show"
  end

  def show

  end
end
