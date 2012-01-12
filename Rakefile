task :generate do
  begin
    site_dir = File.dirname(__FILE__) + "/site"
  
    # Copy all the scripts into the deployment folder
    FileUtils.cp_r(File.dirname(__FILE__) + "/scripts/", File.join(site_dir, "scripts/"))
  
    # Start serve
    server_pid = fork do
      # Prepare the environment
      Dir.chdir(site_dir)
      exec "bundle exec serve"
    end
  
    # Wait for the server to spin up
    sleep(10)
  
    # Go back to the main directory
    Dir.chdir(File.dirname(__FILE__))
  
    # Wget from it like crazy
    `wget --recursive --no-clobber --page-requisites --html-extension --convert-links --no-parent http://localhost:3000`
    
    # Dispense with the server process afterwards
    Process.kill("KILL", server_pid)
    
    FileUtils.mv("localhost:3000", "__site_imprint__")
    
    # And upload that!
    `rsync -rvz __site_imprint__/ serveur.julik.nl:/home/julik/web-apps/framecurve-website/`
  end
end