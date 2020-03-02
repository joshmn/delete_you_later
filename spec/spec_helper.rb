require "bundler/setup"
require 'pry'
require 'rails/all'
require "delete_you_later"

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"
  config.disable_monkey_patching!
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

RSpec::Matchers.define :support_blocks do
  match do |actual|
    actual.is_a? Proc
  end

  def supports_block_expectations?
    true
  end
end

class TestApplication < Rails::Application; end

module Rails
  def self.root
    Pathname.new(File.expand_path("../", __FILE__))
  end

  def self.cache
    @cache ||= ActiveSupport::Cache::MemoryStore.new
  end

  def self.env
    "test"
  end
end

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

ActiveRecord::Schema.verbose = false
ActiveRecord::Schema.define(version: 1) do
  create_table :posts do |t|
    t.datetime :created_at
    t.datetime :updated_at
  end
  create_table :comments do |t|
    t.integer :post_id, null: false
    t.boolean :published, default: true
    t.datetime :created_at
    t.datetime :updated_at
  end
  create_table :likes do |t|
    t.integer :post_id, null: false
    t.datetime :created_at
    t.datetime :updated_at
  end
  add_index :comments, :post_id
  add_index :likes, :post_id
end

class Post < ActiveRecord::Base
  has_many :comments
  has_many :likes
  delete_dependents_later :comments
  destroy_dependents_later :likes
end

class Comment < ActiveRecord::Base
  belongs_to :post
end

class Like < ActiveRecord::Base
  belongs_to :post
end

RSpec.configure do |config|
  config.before(:suite) do
    post = Post.create!
    Comment.create!(post: post)
    Like.create!(post: post)
  end
end

ActiveJob::Base.queue_adapter = :test
Rails.application.instance_variable_set("@initialized", true)
