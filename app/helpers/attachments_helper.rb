module AttachmentsHelper
  ROOT_PATH = Rails.root.join("public", "uploads")
  def download_attachment
    if File.exist?(file_path)
      send_file file_path, filename: @attachment.file_name, type: "application/octet-stream", disposition: "attachment"
      {success: true, message: "File downloaded successfully", status: 200}
    else
      {success: false, message: "File not found", status: 404}
    end
  end

  private
  def file_path
    dir = ROOT_PATH.join(@user.id.to_s)
    FileUtils.mkdir_p(dir) unless File.exist?(dir)

    dir.join(@attachment.id.to_s + "_" + @attachment.file_name)
  end
end
