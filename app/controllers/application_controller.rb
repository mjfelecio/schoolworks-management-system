class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def render_turbo_flash(type, message)
    turbo_stream.append "flash-messages" do
      render partial: "layouts/flash_message",
             locals: { type: type, message: message }
      end
  end

  helper_method :render_turbo_flash
end
