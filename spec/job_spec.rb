describe Cloudq::Job do

  it 'defaults state to queued' do
    subject.queued?.should == true
  end

  it 'changes state to reserved' do
    subject.reserve!
    subject.reserved?.should == true
  end

  it 'changes state to deleted' do
    subject.reserve!
    subject.delete!
    subject.deleted?.should == true
  end

  it 'does not change state from queued to deleted' do
    lambda { subject.delete! }.should raise_error
  end



end
