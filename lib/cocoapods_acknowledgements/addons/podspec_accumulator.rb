require "cocoapods-core"

module CocoaPodsAcknowledgements
  module AddOns
    class PodspecAccumulator

      def initialize(search_path = Pathname("").expand_path)
        @files = Dir[search_path + "**/*.podspec"]
      end

      def podspecs
        @files.map do |path|
          spec = Pod::Specification.from_file(path)
          license_file = spec.license[:file] || "LICENSE"
          license_path = File.join(File.dirname(path), license_file)
          {
            name: spec.name,
            version: spec.version.to_s,
            authors: Hash[spec.authors.map { |k, v| [k, v || ""] }],
            socialMediaURL: spec.social_media_url || "",
            summary: spec.summary,
            licenseType: spec.license[:type],
            licenseText: File.read(license_path),
            homepage: spec.homepage
          }
        end
      end

    end
  end
end