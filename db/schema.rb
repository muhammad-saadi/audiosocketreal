# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_01_20_130007) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "roles", default: [], array: true
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "agreements", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "agreement_type"
    t.index ["agreement_type"], name: "index_agreements_on_agreement_type"
  end

  create_table "albums", force: :cascade do |t|
    t.string "name"
    t.date "release_date"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_albums_on_user_id"
  end

  create_table "artist_profiles", force: :cascade do |t|
    t.string "name"
    t.boolean "exclusive"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "sounds_like"
    t.text "bio"
    t.text "key_facts"
    t.text "social", default: [], array: true
    t.string "status", default: "pending"
    t.string "banner_image_status", default: "rejected"
    t.string "profile_image_status", default: "rejected"
    t.string "country"
    t.string "email"
    t.string "website_link"
    t.string "pro"
    t.string "ipi"
    t.integer "update_count", default: 0
    t.index ["user_id"], name: "index_artist_profiles_on_user_id"
  end

  create_table "artists_collaborators", force: :cascade do |t|
    t.string "status", default: "pending"
    t.string "access"
    t.bigint "artist_id"
    t.bigint "collaborator_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["artist_id", "collaborator_id"], name: "index_artists_collaborators_on_artist_id_and_collaborator_id", unique: true
    t.index ["artist_id"], name: "index_artists_collaborators_on_artist_id"
    t.index ["collaborator_id", "artist_id"], name: "index_artists_collaborators_on_collaborator_id_and_artist_id", unique: true
    t.index ["collaborator_id"], name: "index_artists_collaborators_on_collaborator_id"
  end

  create_table "artists_genres", force: :cascade do |t|
    t.bigint "artist_profile_id"
    t.bigint "genre_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["artist_profile_id"], name: "index_artists_genres_on_artist_profile_id"
    t.index ["genre_id"], name: "index_artists_genres_on_genre_id"
  end

  create_table "audition_musics", force: :cascade do |t|
    t.string "track_link"
    t.bigint "audition_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["audition_id"], name: "index_audition_musics_on_audition_id"
  end

  create_table "auditions", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "artist_name"
    t.string "reference_company"
    t.boolean "exclusive_artist"
    t.string "how_you_know_us"
    t.string "status", default: "pending"
    t.datetime "status_updated_at"
    t.string "remarks"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "assignee_id"
    t.string "sounds_like"
    t.index ["assignee_id"], name: "index_auditions_on_assignee_id"
    t.index ["email", "status"], name: "index_auditions_on_email_and_status"
  end

  create_table "auditions_genres", force: :cascade do |t|
    t.bigint "audition_id"
    t.bigint "genre_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["audition_id"], name: "index_auditions_genres_on_audition_id"
    t.index ["genre_id"], name: "index_auditions_genres_on_genre_id"
  end

  create_table "collaborator_profiles", force: :cascade do |t|
    t.string "pro"
    t.string "ipi"
    t.bigint "artists_collaborator_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "different_registered_name"
    t.index ["artists_collaborator_id"], name: "index_collaborator_profiles_on_artists_collaborator_id"
  end

  create_table "consumer_playlists", force: :cascade do |t|
    t.string "name"
    t.bigint "folder_id"
    t.bigint "consumer_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["consumer_id"], name: "index_consumer_playlists_on_consumer_id"
    t.index ["folder_id"], name: "index_consumer_playlists_on_folder_id"
  end

  create_table "consumer_profiles", force: :cascade do |t|
    t.string "phone"
    t.string "organization"
    t.string "address"
    t.string "city"
    t.string "country"
    t.string "postal_code"
    t.string "youtube_url"
    t.boolean "white_listing_enabled", default: false
    t.bigint "consumer_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["consumer_id"], name: "index_consumer_profiles_on_consumer_id"
  end

  create_table "consumers", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "content_type"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "google_id"
    t.string "facebook_id"
    t.string "linkedin_id"
    t.index ["email"], name: "index_consumers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_consumers_on_reset_password_token", unique: true
  end

  create_table "contact_informations", force: :cascade do |t|
    t.string "name"
    t.string "street"
    t.string "postal_code"
    t.string "city"
    t.string "state"
    t.string "country"
    t.bigint "artist_profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "phone"
    t.string "email"
    t.index ["artist_profile_id"], name: "index_contact_informations_on_artist_profile_id"
  end

  create_table "contents", force: :cascade do |t|
    t.string "key"
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["key"], name: "index_contents_on_key", unique: true
  end

  create_table "curated_playlists", force: :cascade do |t|
    t.string "name"
    t.string "category"
    t.integer "order"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "favorite_follows", force: :cascade do |t|
    t.string "kind"
    t.string "favorite_followable_type"
    t.bigint "favorite_followable_id"
    t.string "favorite_follower_type"
    t.bigint "favorite_follower_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["favorite_followable_type", "favorite_followable_id"], name: "index_favorite_follows_on_favorite_followable"
    t.index ["favorite_follower_type", "favorite_follower_id"], name: "index_favorite_follows_on_favorite_follower"
  end

  create_table "filters", force: :cascade do |t|
    t.string "name"
    t.integer "max_levels_allowed"
    t.boolean "featured"
    t.bigint "parent_filter_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "kind"
    t.index ["parent_filter_id"], name: "index_filters_on_parent_filter_id"
  end

  create_table "folders", force: :cascade do |t|
    t.string "name"
    t.bigint "consumer_id"
    t.bigint "parent_folder_id"
    t.integer "level", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["consumer_id"], name: "index_folders_on_consumer_id"
    t.index ["parent_folder_id"], name: "index_folders_on_parent_folder_id"
  end

  create_table "genres", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "media_filters", force: :cascade do |t|
    t.bigint "filter_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "filterable_type"
    t.bigint "filterable_id"
    t.index ["filter_id"], name: "index_media_filters_on_filter_id"
    t.index ["filterable_type", "filterable_id"], name: "index_media_filters_on_filterable"
  end

  create_table "notes", force: :cascade do |t|
    t.text "description"
    t.string "status", default: "pending"
    t.bigint "user_id"
    t.string "notable_type"
    t.bigint "notable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["notable_type", "notable_id"], name: "index_notes_on_notable"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "payment_informations", force: :cascade do |t|
    t.string "payee_name"
    t.string "bank_name"
    t.string "routing"
    t.string "account_number"
    t.string "paypal_email"
    t.bigint "artist_profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["artist_profile_id"], name: "index_payment_informations_on_artist_profile_id"
  end

  create_table "playlist_tracks", force: :cascade do |t|
    t.text "note"
    t.string "listable_type"
    t.bigint "listable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "order"
    t.string "mediable_type"
    t.bigint "mediable_id"
    t.index ["listable_type", "listable_id"], name: "index_playlist_tracks_on_listable"
    t.index ["mediable_type", "mediable_id"], name: "index_playlist_tracks_on_mediable"
  end

  create_table "publisher_users", force: :cascade do |t|
    t.string "pro"
    t.string "ipi"
    t.bigint "publisher_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["publisher_id"], name: "index_publisher_users_on_publisher_id"
    t.index ["user_id"], name: "index_publisher_users_on_user_id"
  end

  create_table "publishers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "default_publisher", default: false
  end

  create_table "request_limits", force: :cascade do |t|
    t.integer "daily_usage"
    t.date "last_used"
    t.string "request_type"
    t.string "limitable_type"
    t.bigint "limitable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["limitable_type", "limitable_id"], name: "index_request_limits_on_limitable"
  end

  create_table "sfxes", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "keyword"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "duration"
  end

  create_table "tax_informations", force: :cascade do |t|
    t.bigint "artist_profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "tax_id"
    t.index ["artist_profile_id"], name: "index_tax_informations_on_artist_profile_id"
  end

  create_table "track_publishers", force: :cascade do |t|
    t.bigint "track_id"
    t.bigint "publisher_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "percentage", default: 0
    t.index ["publisher_id"], name: "index_track_publishers_on_publisher_id"
    t.index ["track_id"], name: "index_track_publishers_on_track_id"
  end

  create_table "track_writers", force: :cascade do |t|
    t.bigint "track_id"
    t.bigint "artists_collaborator_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "percentage", default: 0
    t.index ["artists_collaborator_id"], name: "index_track_writers_on_artists_collaborator_id"
    t.index ["track_id"], name: "index_track_writers_on_track_id"
  end

  create_table "tracks", force: :cascade do |t|
    t.string "title"
    t.string "status", default: "pending"
    t.bigint "album_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "public_domain"
    t.text "lyrics"
    t.boolean "explicit"
    t.string "composer"
    t.text "admin_note"
    t.text "description"
    t.string "language"
    t.boolean "instrumental"
    t.string "key"
    t.integer "bpm"
    t.bigint "parent_track_id"
    t.string "aims_id"
    t.string "aims_status"
    t.string "aims_error_details"
    t.float "duration"
    t.datetime "publish_date"
    t.boolean "featured", default: false
    t.index ["album_id"], name: "index_tracks_on_album_id"
    t.index ["parent_track_id"], name: "index_tracks_on_parent_track_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "roles", default: [], array: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_agreements", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "agreement_id"
    t.string "status", default: "pending"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "status_updated_at"
    t.string "role"
    t.index ["agreement_id"], name: "index_users_agreements_on_agreement_id"
    t.index ["user_id"], name: "index_users_agreements_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "artists_collaborators", "users", column: "artist_id"
  add_foreign_key "artists_collaborators", "users", column: "collaborator_id"
end
