require 'spec_helper'

RSpec.describe DeleteYouLater::DestroyLaterJob do
  context 'job' do
    it 'destroys associated records' do
      class Comment
        after_destroy do
          post.update(created_at: 0)
        end
      end
      post = Post.create!
      Comment.create!(post: post)
      expect(post.comments.count).to eq(1)
      DeleteYouLater::DestroyLaterJob.perform_now('Post', post.id, :comments)
      post.reload
      expect(post.created_at).to eq(0)
    end
  end
end