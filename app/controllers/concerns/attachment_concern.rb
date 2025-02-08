module AttachmentConcern
  extend ActiveSupport::Concern
  included do
    before_action :set_attachment
  end

  private
  def set_attachment
    # TODO handle if attachment not found
    @attachment = Attachment.find(params.expect(:id))
  end

end