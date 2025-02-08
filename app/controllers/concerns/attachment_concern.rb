module AttachmentConcern
  extend ActiveSupport::Concern
  included do
    before_action :set_attachment
  end

  private
  def set_attachment
    @attachment = Attachment.find_by(id: params.expect(:id))
    if @attachment.nil?
      redirect_to attachments_path, alert: "Attachment not found"
    end
  end
end