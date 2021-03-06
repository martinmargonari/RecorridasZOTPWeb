class Api::ApiController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include DeviseTokenAuth::Concerns::SetUserByToken
  #protect_from_forgery with: :exception
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json'}
  #skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json'}

  def invitado
    if !current_user.rol_id || current_user.rol_id == 5
      render json: {
        errores: ["acceso denegado"]
      }, status: 401
    end
  end

end
