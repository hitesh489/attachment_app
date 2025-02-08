class AttachmentsController < ApplicationController
  include AttachmentConcern
  include AttachmentsHelper

  before_action :set_attachment, only: %i[ show destroy download ]

  # GET /attachments or /attachments.json
  def index
    @attachments = Attachment.where(user: @user)
  end

  # GET /attachments/1 or /attachments/1.json
  def show
    if @attachment&.user == @user
      render action: :show, layout: false
    else
      render plain: "You are not authorized to access this attachment.", status: :unauthorized
    end
  end

  def download
    if @attachment&.user == @user
      result = download_attachment
      if result[:success]
        render :show, status: result[:status], notice: result[:message]
      else
        render plain: result[:message], status: result[:status]
      end
    else
      render plain: "You are not authorized to access this attachment.", status: :unauthorized
    end
  end
  # GET /attachments/new
  def new
    @attachment = Attachment.new
  end

  # POST /attachments or /attachments.json
  def create
    @attachment = new_attachment

    if (uploaded_file = attachment_params[:file].presence)
      if @attachment.save
        File.open(file_path, "wb") do |file|
          file.write(uploaded_file.read)
        end

        redirect_to attachments_path, notice: "Attachment was successfully created." and return
      end
    else
      @attachment.errors.add(:file, "can't be blank")
    end
    render :new, status: 422
  end

  def destroy
    FileUtils.rm(file_path)
    @attachment.destroy!
    redirect_to attachments_path, status: :see_other, notice: "Attachment was successfully destroyed."
  end

  private

  # Only allow a list of trusted parameters through.
  def attachment_params
    params.fetch(:attachment, {}).permit(:title, :description, :file)
  end

  def new_attachment
    _attachment_params = attachment_params
    Attachment.new(
      title: _attachment_params[:title],
      description: _attachment_params[:description],
      file_name: _attachment_params[:file].original_filename,
      user: @user
    )
  end
end
