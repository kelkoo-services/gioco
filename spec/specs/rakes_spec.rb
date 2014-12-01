require 'spec_helper'

describe "gioco:add_badge" do
  include_context "rake"

  it "Try to add an already created noob badge" do
    expect{subject.invoke('noob',100,'comments')}.to raise_error
  end

end
