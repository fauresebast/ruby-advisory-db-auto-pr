require "./lib/helper"
require "./lib/logger"

def get_commit(sha)
  JSON.parse(
    Typhoeus.get(
      "https://api.github.com/repos/rubysec/ruby-advisory-db/commits/#{sha}",
      headers: headers("application/vnd.github.object+json"),
    ).response_body
  )
end

def get_commit_list(since: nil)
  url = "https://api.github.com/repos/rubysec/ruby-advisory-db/commits"
  url += "?since=#{since}" if since

  JSON.parse(
    Typhoeus.get(
      url,
      headers: headers("application/vnd.github.object+json"),
    ).response_body
  )
end

def get_processed_advisories
  gems_list = JSON.parse(
    Typhoeus.get(
      "https://api.github.com/repos/rubysec/ruby-advisory-db/contents/gems",
      headers: headers("application/vnd.github.raw+json")
    ).response_body
  )
  log("get_processed_advisories: #{gems_list.size} gems folders")
  advisories = {}
  gems_list.each_with_index do |gem, index|
    log("get_processed_advisories: #{index}") if (index % 20).zero?
    gem_cve_list = JSON.parse(
      Typhoeus.get(
        gem["git_url"],
        headers: headers("application/vnd.github.object+json")
      ).response_body
    )
    gem_cve_list["tree"].each do |cve_file|
      advisories[cve_file["path"]] = true
    end
    break if advisories.size >= 60
  end
  advisories
end