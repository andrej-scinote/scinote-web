# frozen_string_literal: true

module Toolbars
  class FormsService
    attr_reader :current_user

    include Canaid::Helpers::PermissionsHelper
    include Rails.application.routes.url_helpers

    def initialize(current_user, form_ids: [])
      @current_user = current_user
      @forms = Form.where(id: form_ids)

      @single = @forms.length == 1
    end

    def actions
      return [] if @forms.none?

      [
        access_action
      ].compact
    end

    private

    def access_action
      return unless @single

      {
        name: 'access',
        label: I18n.t('forms.index.toolbar.access'),
        icon: 'sn-icon sn-icon-project-member-access',
        type: :emit
      }
    end
  end
end
