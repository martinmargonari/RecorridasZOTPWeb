class AuditoriaDataAccess

	def self.log user, accion, nombreEntidad, entidad
		auditoria = Auditoria.new
		auditoria.fecha = Time.now
    auditoria.email = user.email
		auditoria.accion = accion
		auditoria.entidad = nombreEntidad
		auditoria.entity_id = entidad.id
    auditoria.descripcion = entidad.getDescripcion
		auditoria.save
	end

end
