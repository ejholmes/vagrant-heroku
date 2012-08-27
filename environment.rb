require 'veewee'

module Environment
  class << self
    def box
      definition_dir = File.expand_path(File.join(File.dirname(__FILE__), 'definitions'))
      @environment = Veewee::Environment.new(:definition_dir =>  definition_dir)
      @definition_name = 'heroku'
      @vd = @environment.definitions[@definition_name]
      @box_name = @definition_name
      @environment.providers['virtualbox'].get_box(@box_name)
    end
  end
end
