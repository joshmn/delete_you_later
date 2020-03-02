require 'spec_helper'

RSpec.describe DeleteYouLater::DeleteLaterJob do
  context 'job' do
    it 'deletes associated records' do
      post = Post.create!
      Comment.create!(post: post)
      expect(post.comments.count).to eq(1)
      DeleteYouLater::DeleteLaterJob.perform_now('Post', post.id, :comments)
      expect(post.comments.count).to eq(0)
    end
  end
end