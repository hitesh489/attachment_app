class PublicLinkController < ApplicationController
  include AttachmentConcern
  include AttachmentsHelper

  skip_before_action :set_current_user, only: [:show]
  skip_before_action :set_attachment, only: [:show]
  allow_unauthenticated_access only: [:show]

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
    if (public_link = PublicLink.find_by(key: params[:key]))
      @attachment = public_link&.attachment
      @user = @attachment&.user
      result = download_attachment
      render plain: result[:message], status: result[:status]
    else
      render plain: "Invalid URL", status: :not_found
    end
  end
end
