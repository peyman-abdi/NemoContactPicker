Pod::Spec.new do |s|
s.name             = "NemoContactPicker"
s.version          = "0.1.3"
s.summary          = "A simple contact picker in a table view for iOS"

s.description      = <<-DESC
A simple contact picker with UITableViewController and customizable appearance with multiselect
DESC

s.homepage         = "https://github.com/peyman-abdi/NemoContactPicker"
s.license          = 'MIT'
s.author           = { "Peyman" => "lord.akinak@gmail.com" }
s.source           = { :git => "https://github.com/peyman-abdi/NemoContactPicker.git", :tag => s.version.to_s }

s.platform     = :ios, '7.0'
s.requires_arc = true

s.source_files = 'Pod/Classes/**/*'
s.resource_bundles = {
	'NemoContactPicker' => ['Pod/Assets/*.png', 'Pod/Classes/*.xib']
}

end
