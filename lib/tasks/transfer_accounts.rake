desc "Transfer users"
task :transfer_users, [:source_nickname, :target_nickname] => :environment do |task, args|
  TransferUserService.new(source_nickname: args.source_nickname, target_nickname: args.target_nickname).call
end