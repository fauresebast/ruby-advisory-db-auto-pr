require "./lib/helper"
require "./lib/logger"

def advisories
  JSON.parse(
    Typhoeus.get(
      "https://api.github.com/advisories",
      headers: headers("application/vnd.github+json"),
      params: {
        ecosystem: "rubygems",
        is_withdrawn: false,
      }
    ).response_body
  )
end

def update_advisories_list(file)
  code = filename_to_advisory_code(file["filename"])
  log("update_advisories_list: #{file["status"]} - #{code}")

  # "added", "removed", "modified", "renamed", "copied", "changed", "unchanged"
  case file["status"]
  when "added"
    File.write("advisories_list", "#{code}\n", mode: "a")
  when "removed"
    lines = File.readlines('advisories_list', chomp: true) - [code]
    File.write("advisories_list", lines.join("\n"))
  when "renamed"
    previous_code = filename_to_advisory_code(file["previous_filename"])
    lines = File.readlines('advisories_list', chomp: true) - [previous_code] + [code]
    File.write("advisories_list", lines.join("\n"))
  end
end

def filename_to_advisory_code(filename)
  File.basename(filename, File.extname(filename))
end