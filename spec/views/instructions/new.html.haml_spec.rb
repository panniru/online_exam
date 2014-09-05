require 'spec_helper'

describe "instructions/new" do
  before(:each) do
    assign(:instruction, stub_model(Instruction,
      :description => "MyString",
      :exam_id => 1,
      :defined_by => 1
    ).as_new_record)
  end

  it "renders new instruction form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", instructions_path, "post" do
      assert_select "input#instruction_description[name=?]", "instruction[description]"
      assert_select "input#instruction_exam_id[name=?]", "instruction[exam_id]"
      assert_select "input#instruction_defined_by[name=?]", "instruction[defined_by]"
    end
  end
end
