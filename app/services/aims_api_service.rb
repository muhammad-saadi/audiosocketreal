class AimsApiService
  BASE_URL = "https://api-demo.aimsapi.com/v1"
  AUTHORIZATION = ENV['AIMS_AUTHORIZATION']

  def self.fields(track, type, filepath = nil)
    track_filters = track.filters.includes(:parent_filter)
    hook_url = ENV['AIMS_HOOK_URL']
    id_client = track.id
    track_file = File.open(filepath) if filepath.present?
    track_name = track.title
    release_year = 1991
    track_description = track.description.to_s
    album_name = track.album.name
    bpm = track.bpm
    music_key = track.key
    lyrics =  'track.lyrics'
    lyrics_language = 'track.language'
    publisher = 'track_publisher'
    artists =  Array(track.album.user.artist_profile.name)
    composers = Array(track.composer)
    music_for = []
    track_number = track.id
    version_tag = 'Null'
    label_name = 'Null'
    label_code = 'Null'
    album_number = track.album.id
    tempo = track_filters.select { |filter| filter.parent_filter.name.downcase.include?('tempos') }.pluck(:name).join(',').to_s
    genres = track_filters.select { |filter| filter.parent_filter.name.downcase.include?('genres') }.pluck(:name)
    sub_genres = track_filters.select{ |filter| filter.parent_filter.name.in?(genres) }.pluck(:name)
    moods = track_filters.select { |filter| filter.parent_filter.name.downcase.include?('moods') }.pluck(:name)
    instruments = track_filters.select { |filter| filter.parent_filter.name.downcase.include?('instruments') }.pluck(:name)
    sub_instruments = track_filters.select{ |filter| filter.parent_filter.name.in?(instruments) }.pluck(:name)

    @options = { headers: { Authorization: AUTHORIZATION }, body: { id_client: id_client, track: track_file, track_name: track_name, release_year: release_year, track_description: track_description, album_name: album_name, tempo: tempo, bpm: bpm, music_key: music_key, lyrics: lyrics, lyrics_language: lyrics_language, artists: artists, composers: composers, publisher: publisher, genres: genres, instruments: instruments, moods: moods, filepath: filepath, music_for: music_for, track_number: track_number, version_tag: version_tag, label_name: label_name, label_code: label_code, album_number: album_number, hook_url: hook_url, detailed: 1 } }
    @options[:body].except!(:id_client, :track, :filepath, :hook_url) if type == 'update'

    return @options
  end

  def self.create_track(track, filepath)
    HTTParty.post("#{BASE_URL}/tracks", fields(track, 'create', filepath)).parsed_response
  end

  def self.delete_track(track)
    @options = { headers: { Authorization: AUTHORIZATION } }
    HTTParty.delete("#{BASE_URL}/tracks/client/#{track.id}", @options).parsed_response
  end

  def self.update_track(track)
    HTTParty.post("#{BASE_URL}/tracks/client/#{track.id}", fields(track, 'update')).parsed_response
  end
end
