require "rubygems"
require "bundler"
Bundler.require

# http://stackoverflow.com/questions/1113422/how-to-bypass-ssl-certificate-verification-in-open-uri
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

require 'open-uri'

class Package
  
  class R < Redcarpet::Render::XHTML
    attr_reader :downloads
    
    def initialize(*a)
      @downloads = []
      super
    end
    
    def link(link, title, content)
      tpl = '<a href="%s" title="%s">%s</a>'
      tpl % [rewrite(link), title, content]
    end

    def image(link, title, alt_text)
      tpl = '<img src="%s" title="%s" alt="%s" />'
      tpl % [rewrite(link), title, alt_text]
    end

    private

    # Ideally this will make links relative
    def rewrite(link)
      return link if link =~ /^http/
      @downloads.push(link)
      File.basename(link)
    end
  end
  
  def self.for(*names)
    names.flatten.map{|name| new(name)}
  end
  
  def initialize(name)
    @name = name
  end
  
  def repo_url
    "https://github.com/guerilla-di/framecurve_%s" % @name
  end
  
  def package!
    render_engine = R.new
    md = Redcarpet::Markdown.new(render_engine)
    
    # Download the readme
    readme_handle = open(File.join(repo_url, "/raw/master/README.markdown"))
    
    rewritten_readme_html = md.render(readme_handle.read)
    
    assets = render_engine.downloads.map do |e| 
      url = File.join('https://github.com/guerilla-di/', e)
      url = url.gsub(/ /, '%20')
      [File.basename(e), open(url)]
    end
    
    # Write out the index.erb
    File.open(File.join(File.dirname(__FILE__), "scripts", @name, "index.erb"), "wb") do | index |
      index.write(rewritten_readme_html)
    end
    
    assets.each do | a |
      # Write out the index.erb
      File.open(File.join(File.dirname(__FILE__), "scripts", @name, a[0]), "wb") do | index |
        index.write(a[1].read)
      end
    end
  end
  
  private
end

repos = Package.for(%w(  aftereffects maya houdini ))
repos.each do | repo |
  repo.package!
end
