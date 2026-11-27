namespace :assets do
  desc "assets precompilation"
  task :precompile do
    system("bundle", "exec", "jekyll", "build", exception: true)
  end
end
