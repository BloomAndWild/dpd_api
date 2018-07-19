require 'spec_helper'

describe DPDApi::XMLFormatter do
  it "works with nested hashes" do
    expect(subject.format_attrs(recipient: { name: "Bloom & Wild" })).to eq(recipient: { name: "Bloom &amp; Wild" })
  end
end
