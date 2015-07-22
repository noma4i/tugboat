module Tugboat
  module Middleware
    class InfoDroplet < Base
      def call(env)
        ocean = env['barge']

        response = ocean.droplet.show env["droplet_id"]

        require 'pry'; binding.pry;

        unless response.success?
          say "Failed to get infor for Droplet: #{response.message}", :red
          exit 1
        end

        droplet = response.droplet

        if droplet.status == "active"
          status_color = GREEN
        else
          status_color = RED
        end

        say
        say "Name:             #{droplet.name}"
        say "ID:               #{droplet.id}"
        say "Status:           #{status_color}#{droplet.status}#{CLEAR}"
        say "IP4:              #{droplet.networks.v4[0].ip_address}"
        say "IP6:              #{droplet.networks.v6[0].ip_address}" unless droplet.networks.v6.empty?
        say "Private IP:       #{droplet.private_ip_address}" if droplet.private_ip_address

        say "Region:           #{droplet.region.name} - #{droplet.region.slug}"
        say "Image:            #{droplet.image.id} - #{droplet.image.name}"
        say "Size:             #{droplet.size_slug}"
        say "Backups Active:   #{!droplet.backup_ids.empty?}"

        @app.call(env)
      end
    end
  end
end

