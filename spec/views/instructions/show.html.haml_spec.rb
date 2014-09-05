require 'spec_helper'

describe "instructions/show" do
  before(:each) do
    @instruction = assign(:instruction, stub_model(Instruction,
      :description => "Description",
      :exam_id => 1,
      :defined_by => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Description/)
    rendered.should match(/1/)
    rendered.should match(/2/)
  end
end
