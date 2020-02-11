require "cocoapods"
require "cocoapods_acknowledgements"
require "cocoapods_acknowledgements/addons/podspec_accumulator"
require "cocoapods_acknowledgements/addons/swift_package_accumulator"
require "cocoapods_acknowledgements/addons/modifiers/pods_plist_modifier"
require "cocoapods_acknowledgements/addons/modifiers/metadata_plist_modifier"

module CocoaPodsAcknowledgements
  module AddOns

    Pod::HooksManager.register("cocoapods-acknowledgements-addons", :post_install) do |context, user_options|
      paths = [*user_options[:add]]
      excluded_names = [*user_options[:exclude]]
      includes_spm = user_options[:with_spm] || false

      acknowledgements = paths.reduce([]) do |results, path|
        accumulator = PodspecAccumulator.new(Pathname(path).expand_path)
        results + accumulator.acknowledgements
      end

      if includes_spm
        spm_acknowledgements = context.umbrella_targets.reduce([]) do |results, target|
          accumulator = SwiftPackageAccumulator.new(target.user_project.path)
          results + accumulator.acknowledgements
        end
        acknowledgements += spm_acknowledgements
      end

      sandbox = context.sandbox if defined? context.sandbox
      sandbox ||= Pod::Sandbox.new(context.sandbox_root)

      context.umbrella_targets.each do |target|
        metadata_plist_modifier = MetadataPlistModifier.new(target, sandbox)
        metadata_plist_modifier.add(acknowledgements.map(&:metadata_plist_item), excluded_names)

        pods_plist_modifier = PodsPlistModifier.new(target, sandbox)
        pods_plist_modifier.add(acknowledgements.map(&:settings_plist_item), excluded_names)
      end
    end

  end
end
