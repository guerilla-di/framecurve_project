task :generate do
  site_dir = File.dirname(__FILE__) + "/site"
  
  # Copy all the scripts into the deployment folder
  FIleUtils.cp_r(File.dirname(__FILE__) + "/scripts", File.join(site_dir, "scripts"))
  
  # Start serve
  server_pid = fork do
    # Prepare the environment
    Dir.chdir(site_dir)
    exec "bundle exec serve"
  end
  
  # Go back to the main directory
  Dir.chdir(File.dirname(__FILE__))
  
  # Wget from it like crazy
  `wget --recursive --no-clobber --page-requisites --html-extension --convert-links --no-parent http://localhost:3000`
  
  Process.kill(server_pid)
end