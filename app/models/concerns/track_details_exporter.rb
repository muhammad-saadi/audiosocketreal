module TrackDetailsExporter
  extend ActiveSupport::Concern

  class_methods do
    def track_detail_sheet(collection)
      io = StringIO.new
      xlsx = Xlsxtream::Workbook.new(io)
      xlsx.write_worksheet 'Sheet1' do |sheet|

        sheet << ['SynchTank ID', 'Parent track', 'MP3 File', 'WAV File', 'AIFF File', 'Title', 'Performed By', 'Album', 'Composer', 'Notes', 'Description', 'Lyrics', 'Language', 'Instrumental', 'Explicit', 'Vocals', 'Key', 'BPM', 'Tempo', 'Genres :: Comma Sep', 'Subgenres :: Comma Sep', 'Moods :: Comma Sep', 'Instruments :: Comma Sep', 'Subinstruments :: Comma Sep']
        sheet << ['id', 'parent_id', 'mp3_filename', 'wav_filename', 'aiff_filename', 'title', 'performed_by', 'album', 'composer', 'notes', 'description', 'lyrics', 'language', 'instrumental', 'explicit', 'vocals', 'musical_key', 'bpm', 'tempo', 'metadata_genres_csv', 'metadata_subgenres_csv', 'metadata_moods_csv', 'metadata_instruments_csv', 'metadata_subinstruments_csv']

        collection.each do |track|

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
          vocals = track.filters.select { |filter| filter.parent_filter.name.downcase.include?('vocals') }.pluck(:name)
          key = track.key
          bpm = track.bpm
          tempo = track.filters.select { |filter| filter.parent_filter.name.downcase.include?('tempos') }.pluck(:name)
          genres = track.filters.select { |filter| filter.parent_filter.name.downcase.include?('genres') }.pluck(:name)
          sub_genres = track.filters.select{ |filter| filter.parent_filter.name.in?(genres) }.pluck(:name)
          moods = track.filters.select { |filter| filter.parent_filter.name.downcase.include?('moods') }.pluck(:name)
          instruments = track.filters.select { |filter| filter.parent_filter.name.downcase.include?('instruments') }.pluck(:name)
          sub_instruments = track.filters.where(parent_filter_id: Filter.where(name: instruments)).pluck(:name)

          sheet << [nil, nil, mp3_filename, wav_filename, aiff_filename, title, performed_by, album, composer, notes, description, lyrics, language, instrumental, explicit, vocals.join(','), key, bpm, tempo.join(','), genres.join(','), sub_genres.join(','), moods.join(','), instruments.join(','), sub_instruments.join(',')]

        end
      end
      xlsx.close
      io.string
    end
  end
end
