ActiveAdmin.register Track do
  config.remove_action_item(:new)
  permit_params :title, :file, :status, :album_id, :public_domain, :publisher_id, :artists_collaborator_id, :lyrics, :explicit, :composer, :description, :language, :instrumental, :key, :bpm, :admin_note, filter_ids: []

  includes :album

  filter :title_cont, as: :string, label: 'Title'
  filter :status, as: :select, collection: -> { tracks_status_list }
  filter :filters, as: :searchable_select
  filter :created_at

  scope :all, default: true
  scope :pending
  scope :unclassified
  scope :approved
  scope :rejected

  action_item 'Filters', only: :index do
    link_to('Filters', '/', id: 'sidebar_toggle')
  end

  batch_action :download do |ids|
    zipline(batch_action_collection.where(id: ids).to_zip, 'tracks.zip')
  end

  batch_action :download_xlsx do |ids|
    io = StringIO.new
    xlsx = Xlsxtream::Workbook.new(io)
    xlsx.write_worksheet 'Sheet1' do |sheet|

      sheet << ['SynchTank ID', 'Parent track', 'MP3 File', 'WAV File', 'AIFF File', 'Title', 'Performed By', 'Album', 'Composer', 'Notes', 'Description', 'Lyrics', 'Language', 'Instrumental', 'Explicit', 'Vocals', 'Key', 'BPM', 'Tempo', 'Genres :: Comma Sep', 'Subgenres :: Comma Sep', 'Moods :: Comma Sep', 'Instruments :: Comma Sep', 'Subinstruments :: Comma Sep']
      sheet << ['id', 'parent_id', 'mp3_filename', 'wav_filename', 'aiff_filename', 'title', 'performed_by', 'album', 'composer', 'notes', 'description', 'lyrics', 'language', 'instrumental', 'explicit', 'vocals', 'musical_key', 'bpm', 'tempo', 'metadata_genres_csv', 'metadata_subgenres_csv', 'metadata_moods_csv', 'metadata_instruments_csv', 'metadata_subinstruments_csv']
      batch_action_collection.where(id: ids).includes(:filters).each do |track|

        mp3_filename = track.file.filename if track.file.content_type == "audio/mpeg"
        wav_filename = track.file.filename if track.file.content_type == "audio/vnd.wave" || track.file.content_type == "audio/wave"
        aiff_filename = track.file.filename if track.file.content_type == "audio/aiff" || track.file.content_type == "audio/x-aiff"
        title = track.title
        performed_by = track.album.user.first_name + " " + track.album.user.last_name
        album = track.album.name
        composer = track.composer
        notes = track.admin_note
        description = track.description
        lyrics = track.lyrics
        language = track.language
        instrumental = track.instrumental ? 1 : 0
        explicit = track.explicit ? 1 : 0
        vocals = track.filters.where(parent_filter_id: Filter.find_by("lower(name) = ?", "vocals")).pluck(:name)
        key = track.key
        bpm = track.bpm
        tempo = track.filters.where(parent_filter_id: Filter.find_by("lower(name) = ?", "tempos")).pluck(:name)
        genres = track.filters.where(parent_filter_id: Filter.find_by("lower(name) = ?", "genres")).pluck(:name)
        sub_genres = track.filters.where(parent_filter_id: Filter.where(name: genres)).pluck(:name)
        moods = track.filters.where(parent_filter_id: Filter.find_by("lower(name) = ?", "moods")).pluck(:name)
        instruments = track.filters.where(parent_filter_id: Filter.find_by("lower(name) = ?", "instruments")).pluck(:name)
        sub_instruments = track.filters.where(parent_filter_id: Filter.find_by(name: instruments)).pluck(:name)

        sheet << [nil, nil, mp3_filename, wav_filename, aiff_filename, title, performed_by, album, composer, notes, description, lyrics, language, instrumental, explicit, vocals.join(','), key, bpm, tempo.join(','), genres.join(','), sub_genres.join(','), moods.join(','), instruments.join(','), sub_instruments.join(',')]

      end
    end
    xlsx.close
    send_data io.string, filename: "tracks_data.xlsx", type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
  end

  index do
    selectable_column
    id_column
    column :title
    column :album
    column :status do |track|
      track.status&.titleize
    end
    column :explicit
    column :public_domain
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :title
      row :file do |track|
        audio_tag(url_for(track.file), controls: true) if track.file.attached?
      end

      row :album
      row :status do |track|
        track.status&.titleize
      end

      row :explicit
      row :lyrics
      row :public_domain
      row :publisher
      row :artists_collaborator
      row :composer
      row :admin_note
      row :description
      row :language
      row :instrumental
      row :key
      row :bpm
      row :created_at
      row :updated_at

      panel 'Filters' do
        @track = Track.find(params[:id])

        table_for @track.filters do
          if @track.filters.blank?
            column 'No Records Found'
          else
            column :id
            column :name
            column :actions do |filter|
              link_to t('active_admin.view'), admin_filter_path(filter), class: 'small button'
            end
          end
        end
      end
    end

    panel 'Notes' do
      @track = Track.find(params[:id])
      table_for @track.notes do
        if @track.notes.blank?
          column 'No Records Found'
        else
          column :id
          column :status
          column :actions do |note|
            link_to 'view', admin_note_path(note), class: 'small button'
          end
        end
      end
    end

    active_admin_comments
  end

  csv do
    column :id
    column :title
    column(:album) { |track| track.album.name }
    column(:status) { |track| track.status&.titleize }
    column(:explicit) { |object| formatted_boolean(object.explicit) }
    column(:public_domain) { |object| formatted_boolean(object.public_domain) }
    column(:created_at) { |object| formatted_datetime(object.created_at.localtime) }
    column(:updated_at) { |object| formatted_datetime(object.updated_at.localtime) }
  end

  form do |f|
    user = f.object.album.user
    f.inputs do
      f.input :title
      f.input :file, as: :file
      f.input :lyrics
      f.input :status, as: :select, collection: tracks_status_list, include_blank: false
      f.input :album, as: :searchable_select, collection: user.albums, include_blank: false
      f.input :public_domain
      f.input :explicit
      f.input :instrumental
      f.input :publisher, as: :searchable_select, collection: user.publishers, include_blank: 'Select a Publisher'
      f.input :artists_collaborator, as: :searchable_select, collection: collaborators_details_list(user),
                                     include_blank: 'Select a Collaborator'

      Filter.parent_filters.includes(sub_filters: [sub_filters: :sub_filters]).each do |filter|
        next unless filter.sub_filters.count.positive?

        f.input :filter_ids, as: :searchable_select, collection: filter.sub_filters, label: filter.name, multiple: true,
                             input_html: { data: { placeholder: "Select #{filter.name}" }, name: '[track][filter_ids][]',
                                           id: filter.id.to_s, class: 'filter_select' }
        next unless filter.max_levels_allowed == 2

        div(class: "#{filter.id}-children") do
          f.input :filter_ids, as: :searchable_select, collection: sub_filter_options(filter, f.object), label: "Sub-#{filter.name}", multiple: true,
                               input_html: { data: { placeholder: "Select Sub-#{filter.name}" }, name: '[track][filter_ids][]',
                                             id: "#{filter.id}-children" }
        end
      end

      f.input :composer
      f.input :admin_note, label: "Notes"
      f.input :description
      f.input :language
      f.input :key
      f.input :bpm
    end

    f.actions do
      f.action :submit
      f.cancel_link(f.object.persisted? ? { action: 'show' } : admin_album_path(f.object.album_id))
    end
  end
end
