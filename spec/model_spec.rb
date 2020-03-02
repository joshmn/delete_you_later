require 'spec_helper'

RSpec.describe DeleteYouLater::Model do
  context 'deletes you later' do
    it 'responds to deletes_dependendents_later' do
      expect(Post).to respond_to(:delete_dependents_later)
    end
    it 'destroying a record enqueues a job' do
      ActiveJob::Base.queue_adapter = :test
      expect {
        Post.first.destroy
      }.to change {
        ActiveJob::Base.queue_adapter.enqueued_jobs.count
      }.by 2
    end
  end
  context 'destroys you later' do
    it 'responds to destroy_dependendents_later' do
      expect(Post).to respond_to(:destroy_dependents_later)
    end
  end
  context 'scoped' do
    it 'respects the scope' do
      class FakePost < ActiveRecord::Base
        self.table_name = 'posts'
        has_many :fake_comments, foreign_key: 'post_id'
        destroy_dependents_later :fake_comments, scope: :unpublished
      end

      class FakeComment < ActiveRecord::Base
        self.table_name = 'comments'
        belongs_to :fake_post, foreign_key: "post_id"
        scope :unpublished, -> { where(published: false) }
      end

      post = FakePost.create!
      FakeComment.create!(fake_post: post, published: false)
      FakeComment.create!(fake_post: post, published: true)
      ActiveJob::Base.queue_adapter = :inline
      expect(post.fake_comments.count).to be(2)
      post.destroy!
      expect(post.fake_comments.count).to be(1)
    end
  end
end