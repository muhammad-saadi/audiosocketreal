module ActiveAdminHelper
  def sub_filter_options(filter, track)
    filter.sub_filters.select { |sub_filter| sub_filter.id.in?(track.filter_ids) }.map(&:filter_options).flatten(1)
  end

  def collaborators_status_list
    ArtistsCollaborator.statuses.keys.map { |key| [key.humanize, key] }
  end

  def collaborators_access_list
    ArtistsCollaborator.accesses.keys.map { |key| [key.humanize, key] }
  end

  def agreement_types
    Agreement.agreement_types.keys.map { |key| [key.titleize, key] }
  end

  def images_status_list
    ArtistProfile::IMAGE_STATUSES.keys.map { |key| [key.to_s.titleize, key] }
  end

  def notes_status_list
    Note.statuses.keys.map { |key| [key.titleize, key] }
  end

  def tracks_status_list
    Track.statuses.keys.map { |key| [key.titleize, key] }
  end

  def users_agreements_status_list
    UsersAgreement.statuses.keys.map { |key| [key.titleize, key] }
  end

  def users_agreement_roles_list
    UsersAgreement.roles.keys.map { |key| [key.titleize, key] }
  end

  def agreements_list
    Agreement.all.map { |agreement| ["Agreement ##{agreement.id}", agreement.id] }
  end

  def collaborators_details_list(user)
    user.collaborators_details.includes(:collaborator).map { |u| [u.collaborator.email, u.id] }
  end

  def artists_collaborators_list
    ArtistsCollaborator.all.map { |artists_collaborator| ["Artist Collaborator ##{artists_collaborator.id}", artists_collaborator.id] }
  end

  def genres_list
    Genre.all
  end

  def pro_list
    [
      ['NS (no society)', 'NS'],
      ['USA - BMI', 'USA - BMI'],
      ['USA - SESAC', 'USA - SESAC'],
      ['USA - ASCAP', 'USA - ASCAP'],
      ['United Kingdom - PRS', 'United Kingdom - PRS'],
      ['Argentina - SADAIC', 'Argentina - SADAIC'],
      ['Australia - APRA', 'Australia - APRA'],
      ['Austria - AKM', 'Austria - AKM'],
      ['Belgium - SABAM', 'Belgium - SABAM'],
      ['Brazil - UBC', 'Brazil - UBC'],
      ['Brazil - ECAD', 'Brazil - ECAD'],
      ['Bulgaria - Musicautor', 'Bulgaria - Musicautor'],
      ['Canada - SOCAN', 'Canada - SOCAN'],
      ['Chile - SCD', 'Chile - SCD'],
      ['Colombia - SAYCO', 'Colombia - SAYCO'],
      ['Croatia - HDS', 'Croatia - HDS'],
      ['Czech Republic - OSA', 'Czech Republic - OSA'],
      ['Denmark - KODA', 'Denmark - KODA'],
      ['Estonia - EAÜ', 'Estonia - EAÜ'],
      ['Finland - TEOSTO', 'Finland - TEOSTO'],
      ['France - SACEM', 'France - SACEM'],
      ['Germany - GEMA', 'Germany - GEMA'],
      ['Greece - AEPI', 'Greece - AEPI'],
      ['Hong Kong - CASH', 'Hong Kong - CASH'],
      ['Hungary - Artisjus', 'Hungary - Artisjus'],
      ['Iceland - STEF', 'Iceland - STEF'],
      ['India - IPRSO', 'India - IPRS'],
      ['Ireland - IMRO', 'Ireland - IMRO'],
      ['Israel - ACUM', 'Israel - ACUM'],
      ['Italy - SIAE', 'Italy - SIAE'],
      ['Japan - JASRAC', 'Japan - JASRAC'],
      ['Lithuania - LATGA-A', 'Lithuania - LATGA-A'],
      ['Malaysia - MACP', 'Malaysia - MACP'],
      ['Mexico - SACM', 'Mexico - SACM'],
      ['Netherlands - BUMA', 'Netherlands - BUMA'],
      ['New Zealand - APRA', 'New Zealand - APRA'],
      ['Norway -  TONO', 'Norway -  TONO'],
      ['Poland - ZAIKS', 'Poland - ZAIKS'],
      ['Portugal - SPA', 'Portugal - SPA'],
      ['Russia - RAO', 'Russia - RAO'],
      ['Singapore - COMPASS', 'Singapore - COMPASS'],
      ['South Africa - SAMRO', 'South Africa - SAMRO'],
      ['Spain - SGAE', 'Spain - SGAE'],
      ['Sweden - STIM', 'Sweden - STIM'],
      ['Switzerland - SUISA', 'Switzerland - SUISA'],
      ['Trinidad & Tobago - COTT', 'Trinidad & Tobago - COTT'],
      ['Turkey - MESAM', 'Turkey - MESAM'],
      ['Uruguay - AGADU', 'Uruguay - AGADU'],
      ['Other', 'other']
    ]
  end
end
