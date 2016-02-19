%w(uploads).each do |folder|
    run "ln -nfs #{config.shared_path}/public/#{folder} #{config.release_path}/public/#{folder}"
end
