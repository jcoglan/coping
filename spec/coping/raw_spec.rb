require "spec_helper"

describe Coping::Raw do
  let :template do
    Coping::Raw.new(<<-RAW)
      The title is: [%= title %]
      
      [% 3.times do |i| -%]
          Repeat \#[%= i %]
      [% end -%]
    RAW
  end
  
  it "compiles the template using local variables" do
    title = "Coping Templates FTW!"
    template.result(binding).strip.should == <<-OUT.strip
      The title is: Coping Templates FTW!
      
      Repeat #0
      Repeat #1
      Repeat #2
    OUT
  end
end

