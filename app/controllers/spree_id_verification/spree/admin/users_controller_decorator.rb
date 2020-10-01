module SpreeIdVerification
  module Spree
    module Admin

      module UsersControllerDecorator
        def verification
          @user = ::Spree::User.find(params[:id])
        end

        def verify
          @user = ::Spree::User.find(params[:id])
          if @user.status.blank?
            @user.status = 'pending'
          end
          @user.verify!

          render :verification
        end

        def reject
          @user = ::Spree::User.find(params[:id])
          if @user.status.blank?
            @user.status = 'pending'
          end
          @user.reject!

          render :verification
        end
      end

    end
  end
end

::Spree::Admin::UsersController.prepend SpreeIdVerification::Spree::Admin::UsersControllerDecorator if ::Spree::Admin::UsersController.included_modules.exclude?(SpreeIdVerification::Spree::Admin::UsersControllerDecorator)
