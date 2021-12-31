module AimsCallbacks
  extend ActiveSupport::Concern

  included do
    after_save :aims_add_track, :aims_delete_track_by_status, :aims_update_track, :aims_replace_file
    after_destroy :aims_delete_track

    def file_path
      [album.name, filename].join('/')
    end

    def delete_aims_fields
      return unless self.aims_id.present?

      self.update(aims_id: nil, aims_status: nil)
    end

    def aims_add_track
      return unless saved_change_to_status?
      return unless approved?

      AimsApiService.create_track(self, create: true)
    end

    def aims_delete_track_by_status
      return unless saved_change_to_status?
      return unless status_previously_was ==  'approved'

      AimsApiService.delete_track(self)
      delete_aims_fields
    end

    def aims_replace_file
      return unless approved?
      return if self.attachment_changes.empty?
      return if id_previously_changed?
      return if self.attachment_changes['mp3_file'].attachable.is_a?(Hash)

      file = self.attachment_changes.first[0]
      filepath = self.attachment_changes["#{file}"].attachable.path

      AimsApiService.delete_track(self)
      AimsApiService.create_track(self, filepath: filepath)
    end

    def aims_delete_track
      AimsApiService.delete_track(self)
    end

    def aims_update_track
      return if saved_change_to_status?
      return unless approved?
      return unless self.attachment_changes.empty?
      return if saved_change_to_aims_id?

      AimsApiService.update_track(self)
    end
  end
end
