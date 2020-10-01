module SpreeIdVerification
  module Spree

    module UserDecorator
      DEFAULT_ADMIN_ROLE = :admin

      def self.prepended(base)
        base.enum status: [:pending, :verified, :rejected],
          _prefix: :status

        base.has_one :id_verification_image, dependent: :destroy,
          class_name: '::SpreeIdVerification::Spree::IdVerificationImage'

        base.validates_associated :id_verification_image, on: :create

        base.class_eval do
          after_create :auto_verify!

          state_machine :status, initial: :pending, action: :save_state do
            event :verify do
              transition to: :verified
            end

            event :reject do
              transition to: :rejected
            end
          end

          alias_method :save_state, :save

          private

          def auto_verify!
            if spree_roles.exists?(name: DEFAULT_ADMIN_ROLE)
              verify!
              save
            end
          end
        end # define state machine
      end

      def id_verification_image=(file)
        build_id_verification_image(attachment: file)
      end
    end

  end
end

if ::Spree::User.included_modules.exclude?(SpreeIdVerification::Spree::UserDecorator)
  ::Spree::User.prepend SpreeIdVerification::Spree::UserDecorator
end
