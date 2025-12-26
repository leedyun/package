
module Cnvrg
  class ImageCli < SubCommandBase

    desc 'image build --image=IMAGE_ID', 'Build image job', :hide => true
    method_option :image_id, :type => :string, :aliases => ["--image"]
    def build_image_job()
      begin
        @cli = Cnvrg::CLI.new
        @cli.verify_logged_in(false)
        @cli.log_start(__method__, args, options)
        @cli.log_message("build image started", Thor::Shell::Color::BLUE)
        image = Image.new(options["image_id"])
        image.build
        @cli.log_message("Image build completed successfully", Thor::Shell::Color::BLUE)
      rescue => e
        @cli.log_message("Image build completed with an error", Thor::Shell::Color::RED)
        @cli.log_error(e)
        exit(1)
      end
    end


  end
end
