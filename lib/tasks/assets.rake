namespace :assets do
  desc "assets precompilation"
  task :precompile do
    system("jekyll build", exception: true)
  end
end
