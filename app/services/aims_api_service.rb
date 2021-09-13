class AimsApiService
  BASE_URL = ENV['AIMS_BASE_URL']
  AUTHORIZATION = ENV['AIMS_AUTHORIZATION']

  def self.track_json(track)
    track_filters = track.filters.includes(:parent_filter)

    {
      id_client: track.id,
      filepath: track.file_path,
      track_name: track.title,
      release_year: 1991,
      track_description: track.description.to_s,
      album_name: track.album.name,
      bpm: track.bpm,
      music_key: track.key,
      lyrics: 'track.lyrics',
      lyrics_language: 'track.language',
      publisher: 'track_publisher',
      artists: Array(track.album.user.artist_profile.name),
      composers: Array(track.composer),
      music_for: [],
      track_number: track.id,
      version_tag: 'Null',
      label_name: 'Null',
      label_code: 'Null',
      album_number: track.album.id,
      tempo: track_filters.select { |filter| filter.parent_filter.name.downcase.include?('tempos') }.pluck(:name).join(',').to_s,
      genres: track_filters.select { |filter| filter.parent_filter.name.downcase.include?('genres') }.pluck(:name),
      moods: track_filters.select { |filter| filter.parent_filter.name.downcase.include?('moods') }.pluck(:name),
      instruments: track_filters.select { |filter| filter.parent_filter.name.downcase.include?('instruments') }.pluck(:name),
      hook_url: UrlHelpers.track_response_api_v1_aims_api_index_url,
      detailed: 1
    }
  end

  def self.fields(track, type)
    options = { headers: { Authorization: AUTHORIZATION }, body: track_json(track) }
    options[:body].except!(:id_client, :track, :filepath, :hook_url) if type == 'update'

    options
  end

  def self.create_track(track, filepath: nil, create: false)
    if create
      track.file.open do |file|
        fields = fields(track, 'create')
        fields[:body][:track] = file
        HTTParty.post("#{BASE_URL}/tracks", fields).parsed_response
      end
    else
      file = filepath.present? ? File.open(filepath) : nil
      fields = fields(track, 'create')
      fields[:body][:track] = file
      HTTParty.post("#{BASE_URL}/tracks", fields).parsed_response
    end
  end

  def self.delete_track(track)
    options = { headers: { Authorization: AUTHORIZATION } }
    HTTParty.delete("#{BASE_URL}/tracks/client/#{track.id}", options).parsed_response
  end

  def self.update_track(track)
    HTTParty.post("#{BASE_URL}/tracks/client/#{track.id}", fields(track, 'update')).parsed_response
  end
end
