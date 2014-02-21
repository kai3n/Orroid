require "rexml/document"
require "rexml/parseexception"
require "rexml/output"
require "rexml/source"
require "rexml/formatters/pretty"
require "rexml/undefinednamespaceexception"

include REXML

class Manifest
	attr_accessor :package
	attr_accessor :minSDK
	attr_accessor :permission
	attr_accessor :main
	
	def initialize
		@permission = Array.new
	end
end

def load_xml(xml_path)
	f = File.new(xml_path, "r")
	doc = f.read
	f.close
	
	$xml = Document.new(doc)
	manifest = Manifest.new
	
	uses_sdk = $xml.root.elements["uses-sdk"]
	
	manifest.package = $xml.root.attributes["package"]
	if uses_sdk != nil
		manifest.minSDK = uses_sdk.attributes["minSdkVersion"]
	end
	
	$xml.root.elements.each do |e|
		if e.name == "uses-permission"
			manifest.permission.push e.attributes["name"]
		end
	end

	return manifest
end