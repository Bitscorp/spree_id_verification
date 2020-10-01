module Spree
  class VerificationMailer < ::Spree::BaseMailer
    # if you are using custom email templates
    if Object.const_defined?(:EmailTemplate)
      prepend_view_path ::EmailTemplate.resolver
    end

    def welcome_email
      # verification pending
      @user = params[:user]
      @user_email = @user.email
      subject = "#{Spree::Store.current.name} #{Spree.t('verification_mailer.welcome_email.subject')}"

      mail(to: @user_email, from: from_address, subject: subject)
    end

    def verified_email
      # you are verified
    end

    def rejected_email
      # you are rejected
    end
  end
end
