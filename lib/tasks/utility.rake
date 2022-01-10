namespace :utility do
  task :unify_filenames do
    Dir["_posts/**/*"].map { |filepath|
      basename = File.basename(filepath)
      dirname = File.dirname(filepath)
      new_basename = basename.gsub(/\d{4}-\d{2}-\d{2}/, "2000-01-01")
      new_filepath = dirname + "/" + new_basename
      if basename != new_basename
        FileUtils.mv filepath, new_filepath
      end
    }
  end
end
