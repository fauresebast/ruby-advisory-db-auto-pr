GITHUB_TOKEN = File.read(".github_token")

def headers(format)
  {
    Accept: format,
    Authorization: "Bearer #{GITHUB_TOKEN}",
    "X-GitHub-Api-Version" => "2022-11-28",
  }
end