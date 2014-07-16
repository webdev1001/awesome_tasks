require "spec_helper"

describe Comment do
  context "incremental numbers" do
    let!(:task){ create :task }
    let!(:comment1){ create :comment, resource: task }
    let!(:comment2){ create :comment, resource: task }

    it "gives comments incremental numbers" do
      comment1.id_per_resource.should eq 1
      comment2.id_per_resource.should eq 2
    end
  end
end
