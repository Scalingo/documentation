module Jekyll
  module ESBuildAssets
    def esbuild_asset_path(input)
      if !@mapping
        root = File.expand_path(File.join(__dir__, "../.."))
        manifest_path = File.join(root, "assets", "manifest.json")
        manifest_content = File.read(manifest_path)
        manifest = JSON.parse(manifest_content)

        @mapping = manifest["outputs"].each.with_object({}) do |(outfile, data), res|
          # CSS are handled differently
          if data["cssBundle"]
            actual_entry = data["entryPoint"].sub("stylePlugin:#{root}/", "")
            res[actual_entry] = data["cssBundle"].sub("src", "")
          elsif data["entryPoint"]
            res[data["entryPoint"]] = outfile.sub("src", "")
          end
        end
      end

      result = @mapping[input]

      raise ArgumentError, "No known asset for #{input}" unless result.present?

      result
    end
  end
end

Liquid::Template.register_filter(Jekyll::ESBuildAssets)
