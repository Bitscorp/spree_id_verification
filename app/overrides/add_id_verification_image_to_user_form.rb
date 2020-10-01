Deface::Override.new(
  virtual_path: 'spree/shared/_user_form',
  name: 'add_id_verification_image_to_user_form',
  insert_after: '[data-hook="signup_below_password_fields"]',
  partial: 'spree/shared/id_verification_fields'
)