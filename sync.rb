#!/usr/bin/env ruby
# encoding: utf-8

# Syncs files from the HSR script share to your local drive.
# Fill in your local settings, your HSR account credentials, create some tasks
# and you're ready to go :-)
# Your contribution is appiciated.
# Requries rsync and mount_smbfs. Tested on Mac OS X 10.7.2 with Ruby 1.9.3dev
#
# Author::  Manuel Alabor (mailto:malabor@hsr.ch)

require 'FileUtils'
require 'yaml'
require 'highline/import'

CONFIG_FILE = Dir.home + "/.hsrsync"
DIRECTORY_VALIDATOR = /[a-zA-Z0-9\/\.\s-:_,]/


##############################################################################
# Functions                                                                  #
##############################################################################
# Mounts a SMB share on a specific mounting point.
def mount_smb(share_url, mount_point)
  unmount(mount_point)  # try to unmount first to be sure :-)  
  Dir.mkdir(mount_point)
  `mount_smbfs #{share_url} #{mount_point}`
end

# Unmounts a volume.
def unmount(mount_point)
  if File.directory?(mount_point)
    `umount #{mount_point}`
    Dir.delete(mount_point)
  end
end

# Creates a directory if it is not already existing.
# Uses mkdir_p to create complete directory-trees.
def create_if_missing(*names)
  names.each do |name|
    FileUtils.mkdir_p(name) unless File.directory?(name)
  end
end

def create_sync_config()
	config = {}
	config["local_mount_point"] = ask("Your local mount Point:") do |q| 
		q.default = "/Volumes/HSRScripts/" 
		q.validate = DIRECTORY_VALIDATOR
	end
	config["local_folder"] = ask("Please enter your root directory where you wan't to place your files:") do |q| 
		q.validate = DIRECTORY_VALIDATOR
	end
	config["remote_username"] = ask("Your HSR username?")
	config["remote_password"] = ask("Your HSR password? (attention: will be saved unencrypted)") { |q| q.echo = false }
	config["tasks"] = []
	
	print "Enter directories you wan't to sync. If you finished entering, enter nothing to quit this loop.\n\n"
	while true
		task = {}
		task["source"] = ask("Enter the remote directory relative to the remote scripts folder:")
		if task["source"] == ""
			break
		end
		task["target"] = ask("Enter the local directory to sync to:")
		config["tasks"] << task
	end
	
	create_if_missing(config["local_mount_point"], config["local_folder"])

	print "Finished configuring. Now writing config file.\n"
	File.new(CONFIG_FILE, "w")
	File.open(CONFIG_FILE, "w") do |f|
		YAML.dump(config, f)
	end
	print "Done writing. Start syncing.\n\n"
	return config
end

##############################################################################
# Check config file                                                          #
##############################################################################

config = (File.exists?(CONFIG_FILE) ? YAML.load_file(CONFIG_FILE) : nil)
if config.nil?
	print "HSR Sync didn't found #{CONFIG_FILE}.\n"
	if agree("Create it for you? [y|n]")
		config = create_sync_config()
	else
		Process.exit
	end
end

remote_username = config['remote_username']
remote_password = config['remote_password']
local_mount_point = config['local_mount_point']
local_folder = config['local_folder']
tasks = config['tasks']

##############################################################################
# SMB-Server & Folder                                                        #
##############################################################################
remote_server = 'c206.hsr.ch'
remote_folder = 'skripte'
remote_url = "smb://#{remote_username}:#{remote_password}@#{remote_server}/#{remote_folder}/"

##############################################################################
# Sync                                                                       #
##############################################################################
puts "Mount \"#{remote_server}/#{remote_folder}/\" to \"#{local_mount_point}\""
mount_smb(remote_url, local_mount_point)

puts "Begin to process #{tasks.count} task(s)"
tasks.each do |task|
  source = "#{local_mount_point}/#{task['source']}"
  target = "#{local_folder}/#{task['target']}"
  create_if_missing(target)
  
  puts "Sync \"#{task['source']}\" to \"#{task['target']}\""
  `rsync --archive -u -v "#{source}" "#{target}"`
end
puts "All tasks processed"

puts "Unmount \"#{local_mount_point}\""
unmount(local_mount_point)
