require 'ostruct'

require "rails/all"

require 'delete_you_later/model'
require 'delete_you_later/delete_later_job'
require 'delete_you_later/destroy_later_job'
require 'delete_you_later/railtie'
require 'delete_you_later/version'

module DeleteYouLater
  class << self
    attr_accessor :configuration
  end

  # sorry.
  def self.configuration
    @configuration ||= OpenStruct.new(batch_size: 100, scope: nil)
  end
end
