module DeleteYouLater
  module Model
    def delete_dependents_later(assoc, scope: DeleteYouLater.configuration.scope, batch_size: DeleteYouLater.configuration.batch_size)
      klass = self.name

      after_commit on: :destroy do
        if send(assoc).exists?
          DeleteLaterJob.perform_later klass, id, assoc, scope: scope, batch_size: batch_size
        end
      end
    end

    def destroy_dependents_later(assoc, scope: DeleteYouLater.configuration.scope, batch_size: DeleteYouLater.configuration.batch_size)
      klass = self.name

      after_commit on: :destroy do
        if send(assoc).exists?
          DestroyLaterJob.perform_later klass, id, assoc, scope: scope, batch_size: batch_size
        end
      end
    end
  end
end