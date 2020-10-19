module SpreeIdVerification
  module Spree

    class IdVerificationImage < ::Spree::Base
      self.table_name = 'spree_id_verification_images'

      include Rails.application.routes.url_helpers

      has_one_attached :attachment

      validate :check_attachment_presence
      validate :check_attachment_content_type

      def get_image_url
        if Rails.env.production?
          self.attachment.service_url
        else
          url_for(self.attachment)
        end
      end

      def accepted_image_types
        %w(image/jpeg image/jpg image/png image/gif)
      end

      def check_attachment_presence
        unless attachment.attached?
          errors.add(:attachment, :attachment_must_be_present)
        end
      end

      def check_attachment_content_type
        if attachment.attached? && !attachment.content_type.in?(accepted_image_types)
          errors.add(:attachment, :not_allowed_content_type)
        end
      end
    end

  end
end
