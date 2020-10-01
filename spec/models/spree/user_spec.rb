require 'spec_helper'

describe Spree::User, type: :model do
  let!(:admin_role) { create(:role, name: 'admin') }
  let!(:user_role) { create(:role, name: 'user') }

  let!(:admin) { build(:user, spree_roles: [admin_role], status: 'pending') }
  let!(:user) { build(:user, spree_roles: [user_role], status: 'pending') }

  describe 'when user is having user role' do
    it 'should be possible to verify identity using id image' do
      user.save!

      expect(user.status).to eq('pending')
      user.verify!
      expect(user.status).to eq('verified')

      user.save!
      user.reload
      expect(user.status).to eq('verified')
    end

    it 'should be saved on verify! automatically' do
      expect(user.status).to eq('pending')
      user.verify!
      user.reload
      expect(user.status).to eq('verified')
    end
  end

  describe 'when user is having admin role' do
    it 'should skip id verification' do
      admin.save!

      expect(admin.status).to eq('verified')

      admin.reload
      expect(admin.status).to eq('verified')
    end
  end

  describe 'id verification with image' do
    let(:fixture) { open(Rails.root.join('..', '..', 'spec', 'fixtures', 'example.png')) }

    it 'should allow to attach id image for verification' do
      expect(user.id_verification_image).not_to be

      image = SpreeIdVerification::Spree::IdVerificationImage.new
      image.attachment.attach(io: fixture, filename: "example.png", content_type: 'image/png')
      user.id_verification_image = image
      user.save!

      expect(user.persisted?).to eq(true)
      user.reload
      expect(user.id_verification_image).to be
    end
  end
end
