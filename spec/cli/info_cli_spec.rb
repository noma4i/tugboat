require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  describe "show" do
    it "shows a droplet with a fuzzy name", :vcr => true do
      @cli.info("droplet-fuzzy-name")

      expect($stdout.string).to eq <<-eos
Droplet fuzzy name provided. Finding droplet ID...done\e[0m, 4288321 (droplet-fuzzy-name)

Name:             droplet-fuzzy-name
ID:               4288321
Status:           \e[32mactive\e[0m
IP4:              177.1.1.1
IP6:              3B03:B0C0:0001:00D0:0000:0000:0308:D001
Region:           London 1 - lon1
Image:            1084211 - Cool Image
Size:             1gb
Backups Active:   true
      eos

    end

    it "shows a droplet with an id", :vcr => true do
      @cli.options = @cli.options.merge(:id => 6213326)
      @cli.info

      expect($stdout.string).to eq <<-eos
Droplet id provided. Finding Droplet...done\e[0m, 6213326 (id-droplet)

Name:             id-droplet
ID:               6213326
Status:           \e[32mactive\e[0m
IP4:              168.36.254.208
Region:           New York 2 - nyc2
Image:            12790328 - 14.04 x64
Size:             512mb
Backups Active:   false
      eos
    end

    it "shows a droplet with a name", :vcr => true do
      @cli.options = @cli.options.merge(:name => "droplet-name")
      @cli.info

      expect($stdout.string).to eq <<-eos
Droplet name provided. Finding droplet ID...done\e[0m, 4288765 (droplet-name)

Name:             droplet-name
ID:               4288765
Status:           \e[32mactive\e[0m
IP4:              48.79.144.140
Region:           London 1 - lon1
Image:            124321 - Rad Image
Size:             1gb
Backups Active:   true
      eos
    end

    it "allows choice of multiple droplets", :vcr => true do
      $stdin.should_receive(:gets).and_return('0')

      @cli.info("fuzzy")

      expect($stdout.string).to eq <<-eos
Droplet fuzzy name provided. Finding droplet ID...Multiple droplets found.

0) fuzzy-1 (6252658)
1) fuzzy-2 (6252661)

Please choose a droplet: ["0", "1"]\x20
Name:             fuzzy-1
ID:               6252658
Status:           \e[32mactive\e[0m
IP4:              40.171.221.88
Region:           New York 2 - nyc2
Image:            12790328 - 14.04 x64
Size:             512mb
Backups Active:   false
      eos
    end

  end

end