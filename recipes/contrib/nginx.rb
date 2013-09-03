require 'erb'

module Deploy
  module Recipes
    class Nginx < Recipe
      default_options port: 80

      on :preconfigure do
        FileUtils.mkdir(config_folder) unless File.exists?(config_folder)

        conf = ERB.new(TMPL).result(binding)

        conf_file = File.open(config_folder.join("#{app.name}.conf"), File::CREAT|File::WRONLY)
        conf_file.write(conf)
        conf_file.close
      end

      def config_folder
        world.root.join('nginx')
      end

      TMPL = <<-EOF
upstream <%= @app.name %> {
  server unix://<%= @paths.shared.join('tmp/sockets', @app.name.to_s + '.sock') %>;
}

server {
  server_name www.<%= @options.host %>;
  rewrite ^(.*) http://<%= @options.host %>$1 permanent;
}

server {
  listen <%= @options.port %>;
  server_name <%= @options.host %>;
  root <%= @paths.current.join('public') %>;

  location / {
    if (!-f $request_filename) {
      proxy_pass http://<%= @app.name %>;
    }
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  }
}
      EOF
    end
  end
end