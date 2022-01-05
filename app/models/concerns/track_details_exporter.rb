module TrackDetailsExporter
  extend ActiveSupport::Concern

  class_methods do
    def track_detail_sheet
      io = StringIO.new
      xlsx = Xlsxtream::Workbook.new(io)

      xlsx.write_worksheet 'Sheet1' do |sheet|
        sheet << ['SynchTank ID', 'Parent track', 'MP3 File', 'WAV File', 'AIFF File', 'Title', 'Performed By', 'Album',
                        'Composer', 'Publishers', 'Writers', 'Notes', 'Description', 'Lyrics', 'Language', 'Instrumental', 'Explicit',
                         'Vocals', 'Key', 'BPM', 'Tempo', 'Genres :: Comma Sep', 'Subgenres :: Comma Sep', 'Moods :: Comma Sep',
                                               'Instruments :: Comma Sep', 'Subinstruments :: Comma Sep']
        sheet << %w[id parent_id mp3_filename wav_filename aiff_filename title performed_by album composer publishers_csv writers_csv notes description lyrics language instrumental explicit vocals musical_key bpm tempo metadata_genres_csv metadata_subgenres_csv metadata_moods_csv metadata_instruments_csv metadata_subinstruments_csv]

        all.each do |track|
          row = ['', '']
          row << track.mp3_file.filename
          row << track.wav_file.filename
          row << track.aiff_file.filename
          row << track.title
          row << track.album.user.full_name
          row << track.album.name
          row << track.composer
          row << track.publishers.pluck(:name).join(', ')
          row << track.track_writers.map(&:collaborator_name).join(', ')
          row << track.admin_note
          row << track.description
          row << track.lyrics
          row << track.language
          row << (track.instrumental ? 1 : 0)
          row << (track.explicit ? 1 : 0)
          row << track.filters.select { |filter| filter.parent_filter.name.downcase.include?('vocals') }.pluck(:name).join(', ')
          row << track.key
          row << track.bpm
          row << track.filters.select { |filter| filter.parent_filter.name.downcase.include?('tempos') }.pluck(:name).join(', ')
          genres = track.filters.select { |filter| filter.parent_filter.name.downcase.include?('genres') }.pluck(:name).join(', ')
          row << genres
          row << track.filters.select { |filter| filter.parent_filter.name.in?(genres) }.pluck(:name).join(', ')
          row << track.filters.select { |filter| filter.parent_filter.name.downcase.include?('moods') }.pluck(:name).join(', ')
          instruments = track.filters.select { |filter| filter.parent_filter.name.downcase.include?('instruments') }.pluck(:name).join(', ')
          row << instruments
          row << track.filters.select { |filter| filter.parent_filter.name.in?(instruments) }.pluck(:name).join(', ')
          sheet << row
        end
      end

      xlsx.close
      io.string
    end
  end
end
