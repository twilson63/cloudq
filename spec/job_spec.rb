require 'spec_helper'

describe Job do
  it 'starts with state queued' do
    subject.queued?.should == true
  end

  it 'does not start with state reserved' do
    subject.reserved?.should == false
  end

  it 'transitions to state reserved' do
    subject.reserve!
    subject.reserved?.should == true
  end

  it 'transitions to state deleted from reserved' do
    subject.reserve!
    subject.delete!
    subject.deleted?.should == true
  end

end

