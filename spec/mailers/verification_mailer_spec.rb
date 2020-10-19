require 'spec_helper'

EMAILS = {
  welcome_email: "successfully registered",
  rejected_email: "is rejected",
  verified_email: "successfully verified"
}

EMAILS.each do |key, value|
  RSpec.shared_examples key do
    it "has #{key} specific text in body" do
      expect(body).to include(value)
    end
    it "has user's email in body" do
      expect(body).to include("Hi")
      expect(body).to include(user.email)
    end
  end
end

RSpec.shared_examples "verification mailer email" do |email_name|
  it 'is sent from current store email address' do
    expect(email.from).to eq([Spree::Store.current.mail_from_address])
  end

  it 'is sent to users email address' do
    expect(email.to).to eq([user.email])
  end

  it 'subject contains store name' do
    expect(email.subject).to include Spree::Store.current.name
  end

  it "subject contains #{email_name} specific text" do
    expect(email.subject).to include Spree.t("verification_mailer.#{email_name}.subject")
  end

  context "text part of #{email_name}" do
    include_examples email_name do
      let(:body) { email.text_part.body.to_s }
    end
  end

  context "html part of #{email_name}" do
    include_examples email_name do
      let(:body) { email.html_part.body.to_s }
    end
  end
end

describe Spree::VerificationMailer, type: :mailer do
  before { create(:store) }
  let(:user) { create(:user) }
  EMAILS.each do |key, value|
    context key.to_s.humanize do
      let!(:email) { Spree::VerificationMailer.with(user: user).send(key) }

      it_behaves_like "verification mailer email", key
    end
  end

  context 'with preference :send_core_emails set to false' do
    it 'sends no email' do
      Spree::Config.set(:send_core_emails, false)
      message = Spree::VerificationMailer.with(user: user).welcome_email
      expect(message.body).to be_blank
    end
  end
end
