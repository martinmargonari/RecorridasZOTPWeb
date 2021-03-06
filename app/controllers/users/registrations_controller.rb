class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    super
    @user.state_id = 1
    @user.rol_id = 5
    @user.save
    AuditoriaDataAccess.log current_user, Auditoria::ALTA, Auditoria::USUARIO, @user

    coordinadores = User.coordinadores(@user.area_id)
    coordinadores.each do |c|
      Enviador.nuevo_voluntario_registrado(@user, c).deliver_now
    Enviador.nuevo_voluntario_registrado_diego(@user).deliver_now
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [{jornada_ids: []}, :name, :apellido, :area_id, :area_id, :telefono, :dia, :fecha_nacimiento])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [{jornada_ids: []}, :name, :apellido, :area_id, :telefono, :dia, :fecha_nacimiento])
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    #super(resource)
    new_user_session_path
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    #super(resource)
    new_user_session_path
  end
end
