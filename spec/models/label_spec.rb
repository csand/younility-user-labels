describe Label do
  before(:each) { @label = FactoryGirl.create(:label) }

  subject { @label }

  it { should respond_to(:name, :color) }

  it 'has validation error if name and color are not unique' do
    expect { FactoryGirl.create(:label) }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
