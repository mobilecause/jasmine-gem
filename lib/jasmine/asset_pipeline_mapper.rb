class Jasmine::AssetPipelineMapper

  def self.context
    context = ::Rails.application.assets.context_class
    begin
      context.extend(::Sprockets::Helpers::IsolatedHelper)
    rescue NameError => e
      puts "#{__FILE__}:#{__LINE__} #{e}.  Proceeding without it (probably okay for Rails 3.1, otherwise a bug)."
    end
    context.extend(::Sprockets::Helpers::RailsHelper)
  end

  def initialize(context = Jasmine::AssetPipelineMapper.context)
    @context = context
  end

  def files(src_files)
    src_files.map do |src_file|
    filename = src_file.gsub(/^assets\//, '').gsub(/\.js$/, '')
    @context.asset_paths.asset_for(filename, 'js').to_a.map { |p| @context.asset_path(p).gsub(/^\//, '') + "?body=true" }
    end.flatten.uniq
  end
end
