class Notificacion < ActiveRecord::Base
  belongs_to :frecuencia_tipo
  belongs_to :notificacion_tipo
  belongs_to :state
  has_many :notificacion_roles
  has_many :roles, :through => :notificacion_roles
  accepts_nested_attributes_for :roles

  filterrific(
    available_filters: [
        :search_query
    ]
  )

  scope :search_query, lambda { |query|
    return nil  if query.blank?

    # condition query, parse into individual keywords
    terms = query.downcase.split(/\s+/)

    # replace "*" with "%" for wildcard searches,
    # append '%', remove duplicate '%'s
    terms = terms.map { |e|
    (e.gsub('*', '%') + '%').gsub(/%+/, '%')
    }
    # configure number of OR conditions for provision
    # of interpolation arguments. Adjust this if you
    # change the number of OR conditions.
    num_or_conds = 1
    where(
    terms.map { |term|
      "(LOWER(notificaciones.titulo) LIKE ?)"
    }.join(' AND '),
    *terms.map { |e| [e] * num_or_conds }.flatten
    )
  }

  scope :activas, -> { where.not(state_id: 3).order(fecha_desde: :desc) }

  def frecuencia
    "#{frecuencia_cant} #{frecuencia_tipo.nombre if !frecuencia_tipo.nil?}"
  end

  def getDescripcionAuditoria
    return "Título: #{titulo} Subtítulo: #{titulo} Tipo: #{notificacion_tipo.nombre if !notificacion_tipo.nil?} Fecha desde: #{fecha_desde} Fecha hasta: #{fecha_hasta} Descripción: #{descripcion} Frecuencia #{frecuencia}"
  end
end
