ActiveAdmin.register Sfx do
  permit_params :title, :wav_file, :aiff_file, :mp3_file, :description, :keyword, filter_ids: []

  includes file_attachment: :blob

  action_item 'Filters', only: :index do
    link_to('Filters', '/', id: 'sidebar_toggle')
  end

  member_action :remove_file, method: :delete do
    blob = Sfx.find(params[:id]).send(params[:type]).blob
    @type = params[:type]
    return if blob.blank?

    blob.attachments.first.purge
  end

  batch_action :download do |ids|
    zipline(batch_action_collection.where(id: ids).to_zip, 'sfxes.zip')
  end

  index do
    selectable_column
    id_column
    column :title do |sfx|
      link_to sfx.title, admin_sfx_path(sfx)
    end
    column :description
    column :keyword
    column :wav_file do |sfx|
      audio_tag(url_for(sfx.wav_file), controls: true) if sfx.wav_file.attached?
    end
    column :aiff_file do |sfx|
      audio_tag(url_for(sfx.aiff_file), controls: true) if sfx.aiff_file.attached?
    end
    column :mp3_file do |sfx|
      audio_tag(url_for(sfx.mp3_file), controls: true) if sfx.mp3_file.attached?
    end
    actions
  end

  show do
    attributes_table do
      row :title
      row "WAV Music File" do |sfx|
        audio_tag(url_for(sfx.wav_file), controls: true) if sfx.wav_file.attached?
      end
      row "AIFF Music File" do |sfx|
        audio_tag(url_for(sfx.aiff_file), controls: true) if sfx.aiff_file.attached?
      end
      row "MP3 Music File" do |sfx|
        audio_tag(url_for(sfx.mp3_file), controls: true) if sfx.mp3_file.attached?
      end

      row :duration
      row :description
      row :keyword
      row :created_at, &:formatted_created_at
      row :updated_at, &:formatted_updated_at

      panel 'Filters' do
        @sfx = Sfx.find(params[:id])

        table_for @sfx.filters do
          if @sfx.filters.blank?
            column 'No Records Found'
          else
            column :id
            column :name
            column :actions do |filter|
              link_to t('active_admin.view'), admin_sfx_filter_path(filter), class: 'small button'
            end
          end
        end
      end
    end

    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :wav_file, as: :file , label: "WAV Music File"
      div class: 'file-hint' do
        span 'Existing File: ' + file_hint(f.object, Sfx::AUDIO_TYPES[:wav_file]), id: 'sfx-hint', class: 'sfx_existing_wav_file'
        span link_to 'x', remove_file_admin_sfx_path(f.object, type: Sfx::AUDIO_TYPES[:wav_file]), id: 'sfx_wav_file', class: 'remove-sfx-file', data: { confirm: 'Are you sure you want to remove this audio?', caller: 'wav_file' }, method: :delete, remote: true if f.object.wav_file.blob&.persisted?
      end
      f.input :aiff_file, as: :file , label: "AIFF Music File"
      div class: 'file-hint' do
        span 'Existing File: ' + file_hint(f.object, Sfx::AUDIO_TYPES[:aiff_file]), id: 'sfx-hint', class: 'sfx_existing_aiff_file'
        span link_to 'x', remove_file_admin_sfx_path(f.object, type: Sfx::AUDIO_TYPES[:aiff_file]), id: 'sfx_aiff_file', class: 'remove-sfx-file', data: { confirm: 'Are you sure you want to remove this audio?', caller: 'aiff_file' }, method: :delete, remote: true if f.object.aiff_file.blob&.persisted?
      end
      f.input :mp3_file, as: :file , label: "MP3 Music File"
      div class: 'file-hint' do
        span 'Existing File: ' + file_hint(f.object, Sfx::AUDIO_TYPES[:mp3_file]), id: 'sfx-hint', class: 'sfx_existing_mp3_file'
        span link_to 'x', remove_file_admin_sfx_path(f.object, type: Sfx::AUDIO_TYPES[:mp3_file]), id: 'sfx_mp3_file', class: 'remove-sfx-file', data: { confirm: 'Are you sure you want to remove this audio?', caller: 'mp3_file' }, method: :delete, remote: true if f.object.mp3_file.blob&.persisted?
       end

      br

      Filter.parent_filters.sfx.includes(sub_filters: [sub_filters: :sub_filters]).each do |filter|
        next unless filter.sub_filters.size.positive?

        f.input :filter_ids, as: :searchable_select, collection: filter.sub_filters, label: filter.name, multiple: true, input_html: { data: { placeholder: "Select #{filter.name}" }, name: '[sfx][filter_ids][]',
                id: filter.id.to_s, class: 'filter_select' }

        next unless filter.max_levels_allowed == 2

        div(class: "#{filter.id}-children") do
          f.input :filter_ids, as: :searchable_select, collection: sub_filter_options(filter, f.object), label: "Sub-#{filter.name}", multiple: true,
                               input_html: { data: { placeholder: "Select Sub-#{filter.name}" }, name: '[sfx][filter_ids][]',
                                             id: "#{filter.id}-children" }
        end
      end

      f.input :description, input_html: { class: 'autogrow', rows: 4, cols: 20 }
      f.input :keyword
    end

    f.actions do
      f.action :submit
      f.cancel_link(f.object.persisted? ? { action: 'show' } : admin_sfxes_path)
    end
  end
end
