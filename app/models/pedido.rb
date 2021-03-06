class Pedido < ApplicationRecord
    belongs_to :person
    belongs_to :state

    validates :fecha, presence: true
    validates :person, presence: true
    validates :descripcion, presence: true

 self.per_page = 20

  filterrific(
    available_filters: [
      :search_query,
      :with_area_id,
      :with_zone_id,
      :with_person_id,
      :is_complete,
    ]
  )

  scope :search_query, lambda { |query|
    return nil  if query.blank?

    # condition query, parse into individual keywords
    terms = query.to_s.downcase.split(/\s+/)

    # replace "*" with "%" for wildcard searches,
    # append '%', remove duplicate '%'s
    terms = terms.map { |e|
    (e.gsub('*', '%') + '%').gsub(/%+/, '%')
    }
    # configure number of OR conditions for provision
    # of interpolation arguments. Adjust this if you
    # change the number of OR conditions.
    num_or_conds = 1

    joins(:person).where(
    terms.map { |term|
      "(LOWER(people.nombre) LIKE ?)"
    }.join(' AND '),
    *terms.map { |e| [e] * num_or_conds }.flatten
    )
  }

  scope :with_area_id, lambda { |area_id|
    joins(person: [{zone: :area}]).where("areas.id = ?", area_id)
  }

  scope :with_zone_id, lambda { |zone_id|
    joins(person: :zone).where("zones.id = ?", zone_id)
  }

  scope :with_person_id, lambda { |person_id|
    joins(:person).where("people.id = ?", person_id)
  }

  scope :is_complete, lambda { |is_complete|
    if is_complete == 'Si'
      where("completado = ?", 1)
    else
      where("completado = ? or completado is null", 0)
    end
  }

  scope :activos, -> { where.not(state_id: 3).order(fecha: :desc) }

  def estaCompletado
    return self.completado ? 'Si' : 'No'
  end

  def getDescripcionAuditoria
    return "Persona: #{person.full_name if !person.nil?} Fecha: #{fecha.to_date()} Descripción: #{descripcion}"
  end
end
