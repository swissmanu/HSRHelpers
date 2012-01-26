#!/usr/bin/env ruby

# Syncs files from the HSR script share to your local drive.
# Fill in your local settings, your HSR account credentials, create some tasks
# and you're ready to go :-)
# Your contribution is appiciated.
# Requries rsync and mount_smbfs. Tested on Mac OS X 10.7.2 with Ruby 1.9.2
#
# Author::  Manuel Alabor (mailto:malabor@hsr.ch)

require 'FileUtils'

##############################################################################
# Configuration                                                              #
##############################################################################
# Where do you want to mount the scriptshare temporarly?
local_mount_point = "/Users/manuel/HSR/scriptshare"

# Specify the root directory, where you want to place your files.
# When specifying the :target for your sync tasks, these directory are based
# on this folder.
local_folder = "/Users/manuel/HSR/Sem 6 - 2012"

# Your HSR account credentials:
remote_username = '___INSERT_YOUR_USERNAME___'
remote_password = '___INSERT_YOUR_PASSWORD___'

##############################################################################
# Tasks                                                                      #
##############################################################################
tasks = [{
  :source => 'Informatik/Fachbereich/Betriebssystemkonzepte/BsKon/',
  :target => 'BsKon/Skriptserver/'
},{
  :source => 'Informatik/Fachbereich/Datenbanksysteme_2/Dbs2/',
  :target => 'Dbs2/Skriptserver/'
},{
  :source => 'Informatik/Fachbereich/Software-Engineering_3/SE3/',
  :target => 'SE3/Skriptserver/'
},{
  :source => 'Informatik/Fachbereich/Verteilte_SW-Systeme/Vss/',
  :target => 'Vss/Skriptserver/'
}]

##############################################################################
# SMB-Server & Folder                                                        #
##############################################################################
remote_server = 'c206.hsr.ch'
remote_folder = 'skripte'
remote_url = "smb://#{remote_username}:#{remote_password}@#{remote_server}/#{remote_folder}/"


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

##############################################################################
# Sync                                                                       #
##############################################################################
puts "Mount \"#{remote_server}/#{remote_folder}/\" to \"#{local_mount_point}\""
mount_smb(remote_url, local_mount_point)

puts "Begin to process #{tasks.count} task(s)"
tasks.each do |task|
  source = "#{local_mount_point}/#{task[:source]}"
  target = "#{local_folder}/#{task[:target]}"
  create_if_missing(target)
  
  puts "Sync \"#{task[:source]}\" to \"#{task[:target]}\""
  `rsync --archive -u -v "#{source}" "#{target}"`
end
puts "All tasks processed"

puts "Unmount \"#{local_mount_point}\""
unmount(local_mount_point)