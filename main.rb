require "json"
require "typhoeus"
require "./lib/advisories"
require "./lib/logger"
require "./lib/ruby-advisory-db"

last_processed_commit = get_commit("69dceadc1ac7205b67ec1a7a1d7bc32d89c49ebf")

# TODO: to init project, populate the list of advisories codes

loop do
  last_processed_commit_date = last_processed_commit.dig("commit", "committer", "date")
  last_commits = get_commit_list(since: last_processed_commit_date)
  if last_commits.size > 1
    log("main.rb: new commit(s) identified")
    last_commits[...-1].each do |commit| # our last_processed_commit is included
      log("main.rb: new commit - #{commit["sha"]}")
      commit_data = get_commit(commit["sha"])
      commit_data["files"].each do |file|
        update_advisories_list(file)
      end
    end
  end
  exit
end