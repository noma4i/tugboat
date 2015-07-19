module Tugboat
  module Middleware
    class InfoDroplet < Base
      def call(env)
        ocean = env['barge']

        req = ocean.droplet.show env["droplet_id"]

        if req.status == "ERROR"
          say "#{req.status}: #{req.error_message}", :red
          exit 1
        end

        droplet = req.droplet

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
        say "IP6:              #{droplet.networks.v6[0].ip_address}"

        if droplet.private_ip_address
	        say "Private IP:       #{droplet.private_ip_address}"
	      end

        say "Region:           #{droplet.region.name} - #{droplet.region.slug}"
        say "Image:            #{droplet.image.id} - #{droplet.image.name}"
        say "Size:             #{droplet.size_slug.upcase}"
        say "Backups Active:   #{!droplet.backup_ids.empty?}"

        @app.call(env)
      end
    end
  end
end

