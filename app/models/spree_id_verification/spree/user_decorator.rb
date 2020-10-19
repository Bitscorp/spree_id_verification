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
          after_create :send_welcome_email, if: :status_pending?

          state_machine :status, initial: :pending, action: :save_state do
            event :verify do
              transition to: :verified
            end
            after_transition to: :verified, do: :send_verified_email

            event :reject do
              transition to: :rejected
            end
            after_transition to: :verified, do: :send_rejected_email
          end

          alias_method :save_state, :save

          private

          def auto_verify!
            if spree_roles.exists?(name: 'admin')
              verify!
              save
            end
          end

          def send_welcome_email
            ::Spree::VerificationMailer.with(user: self).welcome_email.deliver_later
          end

          def send_verified_email
            ::Spree::VerificationMailer.with(user: self).verified_email.deliver_later
          end

          def send_rejected_email
            ::Spree::VerificationMailer.with(user: self).rejected_email.deliver_later
          end
        end # define state machine
      end

      # to make form field work
      def id_verification_image=(file)
        build_id_verification_image(attachment: file)
      end
    end

  end
end

if ::Spree::User.included_modules.exclude?(SpreeIdVerification::Spree::UserDecorator)
  ::Spree::User.prepend SpreeIdVerification::Spree::UserDecorator
end
