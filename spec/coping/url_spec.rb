require "spec_helper"

describe Coping::URL do
  let :input do
    "Some &really?! =cool= <text>"
  end
  
  let :number do
    42
  end
  
  it "allows the scheme to be templated" do
    template = Coping::URL.new("[%= scheme %]://example.com/")
    scheme = "http"
    template.result(binding).should == "http://example.com/"
  end
  
  it "allows the domain to be templated" do
    template = Coping::URL.new("//[%= domain %]/")
    domain = "jcoglan.com"
    template.result(binding).should == "//jcoglan.com/"
  end
  
  it "allows the port to be templated" do
    template = Coping::URL.new("//example.com:[%= port %]/")
    port = 4567
    template.result(binding).should == "//example.com:4567/"
  end
  
  it "allows the path to be templated" do
    template = Coping::URL.new("//example.com[%= path %]")
    path = "/hello"
    template.result(binding).should == "//example.com/hello"
  end
  
  it "CGI-encodes text destined for query string values" do
    template = Coping::URL.new("/foo?q=[%= input %]")
    template.result(binding).should == "/foo?q=Some+%26really%3F%21+%3Dcool%3D+%3Ctext%3E"
  end
  
  it "CGI-encodes numbers destined for query string values" do
    template = Coping::URL.new("/foo?q=[%= number %]")
    template.result(binding).should == "/foo?q=42"
  end
  
  it "CGI-encodes blank values" do
    template = Coping::URL.new("/foo?q=&n=[%= number %]")
    number = ""
    template.result(binding).should == "/foo?q=&n="
  end
  
  it "CGI-encodes multiple key-value pairs" do
    template = Coping::URL.new("/foo?q=[%= input %]&n=[%= number %]")
    template.result(binding).should == "/foo?q=Some+%26really%3F%21+%3Dcool%3D+%3Ctext%3E&n=42"
  end
  
  it "CGI-encodes name-value maps" do
    template = Coping::URL.new("/foo?[%= params %]")
    params = {:q => input}
    template.result(binding).should == "/foo?q=Some+%26really%3F%21+%3Dcool%3D+%3Ctext%3E"
  end
  
  it "matches URLs with no query string" do
    template = Coping::URL.new("/foo?")
    template.result(binding).should == "/foo?"
    template = Coping::URL.new("/foo")
    template.result(binding).should == "/foo"
  end
  
  it "matches a URL with a domain" do
    template = Coping::URL.new("//example.com/foo?q=[%= number %]")
    template.result(binding).should == "//example.com/foo?q=42"
  end
  
  it "matches a URL with a domain and port" do
    template = Coping::URL.new("//example.com:4567/foo?q=[%= number %]")
    template.result(binding).should == "//example.com:4567/foo?q=42"
  end
  
  it "matches a URL with a scheme" do
    template = Coping::URL.new("https://example.com/foo?q=[%= number %]")
    template.result(binding).should == "https://example.com/foo?q=42"
  end
  
  it "matches a URL with a hash" do
    template = Coping::URL.new("https://example.com/foo?q=[%= number %]#something")
    template.result(binding).should == "https://example.com/foo?q=42#something"
  end
end

