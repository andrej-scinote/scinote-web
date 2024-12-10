# frozen_string_literal: true

module Lists
  class FormSerializer < ActiveModel::Serializer
    attributes :id, :name, :description, :published_on, :published_by, :updated_at

    has_many :form_fields, key: :form_fields, serializer: FormFieldSerializer

    def published_by
      object.published_by&.full_name
    end

    def published_on
      I18n.l(object.published_on, format: :full) if object.published_on
    end

    def updated_at
      I18n.l(object.updated_at, format: :full) if object.updated_at
    end
  end
end
