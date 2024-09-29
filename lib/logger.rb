def log(message)
  puts "#{Time.now} - #{message}"
  return
  File.write("app.log", "", "w") if File.size("app.log") > 1_073_741_824 # 1 Go

  File.write("app.log", "a") do |f|
    f.write "#{Time.current} - #{message}\n"
  end
end