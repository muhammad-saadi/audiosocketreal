# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

['Blues', 'Classic Rock', 'Country', 'Dance', 'Disco', 'Funk', 'Grunge',
 'Hip-Hop', 'Jazz', 'Metal', 'New Age', 'Oldies', 'Other', 'Pop', 'R&B',
 'Rap', 'Reggae', 'Rock', 'Techno', 'Industrial', 'Alternative', 'Ska',
 'Death Metal', 'Pranks', 'Soundtrack', 'Euro-Techno', 'Ambient',
 'Trip-Hop', 'Vocal', 'Jazz+Funk', 'Fusion', 'Trance', 'Classical',
 'Instrumental', 'Acid', 'House', 'Game', 'Sound Clip', 'Gospel',
 'Noise', 'AlternRock', 'Bass', 'Soul', 'Punk', 'Space', 'Meditative',
 'Instrumental Pop', 'Instrumental Rock', 'Ethnic', 'Gothic',
 'Darkwave', 'Techno-Industrial', 'Electronic', 'Pop-Folk',
 'Eurodance', 'Dream', 'Southern Rock', 'Comedy', 'Cult', 'Gangsta',
 'Top 40', 'Christian Rap', 'Pop/Funk', 'Jungle', 'Native American',
 'Cabaret', 'New Wave', 'Psychadelic', 'Rave', 'Showtunes', 'Trailer',
 'Lo-Fi', 'Tribal', 'Acid Punk', 'Acid Jazz', 'Polka', 'Retro',
 'Musical', 'Rock & Roll', 'Hard Rock', 'Folk', 'Folk-Rock',
 'National Folk', 'Swing', 'Fast Fusion', 'Bebob', 'Latin', 'Revival',
 'Celtic', 'Bluegrass', 'Avantgarde', 'Gothic Rock', 'Progressive Rock',
 'Psychedelic Rock', 'Symphonic Rock', 'Slow Rock', 'Big Band',
 'Chorus', 'Easy Listening', 'Acoustic', 'Humour', 'Speech', 'Chanson',
 'Opera', 'Chamber Music', 'Sonata', 'Symphony', 'Booty Bass', 'Primus',
 'Porn Groove', 'Satire', 'Slow Jam', 'Club', 'Tango', 'Samba',
 'Folklore', 'Ballad', 'Power Ballad', 'Rhythmic Soul', 'Freestyle',
 'Duet', 'Punk Rock', 'Drum Solo', 'Acapella', 'Euro-House', 'Dance Hall', 'Indie Electronic', 'Trap', 'Grime',
 'Alt Hip Hop', 'Latin', 'Cinematic', 'Orchestral', 'Trailer', 'Indie Electronic', 'Trap', 'Grime', 'Alt Hip Hop',
 'Latin', 'Cinematic', 'Orchestral', 'Trailer'].each do |genre|
  Genre.find_or_create_by(name: genre)
end
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?
