require 'spec_helper'

describe Spree::VerificationMailer, type: :mailer do
  let(:store) { create(:store) }
  let(:user) { create(:user) }

  context ':from not set explicitly' do
    it 'falls back to spree config' do
      message = Spree::VerificationMailer.with(user).welcome_email
      expect(message.from).to eq([Spree::Store.current.mail_from_address])
    end
  end

  it "doesn't aggressively escape double quotes in confirmation body" do
    message = Spree::VerificationMailer.with(user).welcome_email
    expect(message.body).not_to include('&quot;')
  end

  context 'welcome email' do
    let!(:welcome_email) { Spree::VerificationMailer.with(user).welcome_email }

    specify do
      # expect(welcome_email.body).not_to include("text")
      expect(welcome_email).to have_body_text("Hi")
      expect(welcome_email).to have_body_text(user.email)
    end

    it 'is sent from current store email address' do
      welcome_email = Spree::VerificationMailer.with(user).welcome_email
      expect(welcome_email.from).to have_content(Spree::Store.current.mail_from_address)
    end

    it 'is sent to users email address' do
      welcome_email = Spree::VerificationMailer.with(user).welcome_email
      expect(welcome_email.to).to have_content(user.email)
    end

    it 'subject contains some text' do
      welcome_email = Spree::VerificationMailer.with(user).welcome_email
      expect(welcome_email.subject).to have_content(Spree::Store.current.name)
      expect(welcome_email.subject).to have_content(Spree.t('verification_mailer.welcome_email.subject'))
    end

    it 'body users email' do
      welcome_email = Spree::VerificationMailer.with(user).welcome_email
      # TODO: check what is parts
      expect(welcome_email.body.parts.first).to have_text(vendors_item.product.name)
      expect(welcome_email.body.parts.last).to have_text(vendors_item.product.name)
    end
  end

  context 'with preference :send_core_emails set to false' do
    it 'sends no email' do
      Spree::Config.set(:send_core_emails, false)
      message = Spree::VerificationMailer.with(user).welcome_email
      expect(message.body).to be_blank
    end
  end
end
