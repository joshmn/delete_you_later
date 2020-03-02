module DeleteYouLater
  class DeleteLaterJob < ActiveJob::Base
    def perform(model_name, model_id, assoc, scope: DeleteYouLater.configuration.scope, batch_size: DeleteYouLater.configuration.batch_size)
      model = model_name.constantize
      association = model.reflect_on_association(assoc.to_sym)
      dependent = association.klass
      foreign_key = association.foreign_key
      last_seen = 0
      loop do
        ids = association.klass.select(:id).where(foreign_key => model_id).where("id > ?", last_seen)
        if scope
          ids = ids.public_send(scope)
        end
        ids = ids.limit(batch_size).pluck(:id)
        break if ids.empty?
        last_seen = ids.last
        dependent.where(id: ids).find_each do |record|
          record.delete
        end
      end
    end
  end
end