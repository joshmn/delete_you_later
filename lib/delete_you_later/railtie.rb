module DeleteYouLater
  class Railtie < ::Rails::Railtie
    ActiveSupport.on_load(:active_record) { extend DeleteYouLater::Model }
  end
end
