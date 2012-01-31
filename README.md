# HSRHelpers
Some Ruby scripts which might be helpful for HSR students :-)

## Sync
Create a job file:

	# HSRScripts Job
	# Mirrors script folders from the HSR share to the local machine and copies
	# the files afterwards into the local dropbox folder.
	HsrHelpers::Sync::Job.new(:hsrscripts) do
	  # Tweaking the paths. Not related to the sync-tool, but for convenience:
	  local_hsr_root = '/Users/manuel/HSR'
	  current_semester = 'Sem 6 - 2012'
	  local_path = "#{local_hsr_root}/#{current_semester}/"
	  dropbox_path = "/Users/manuel/Dropbox/HSR/#{current_semester}"
  
	  # Mount the script share.
	  # Note: You can use :hsrscripts afterwards in the one_way statement to
	  #       reference to this share.
	  mount :hsrscripts do |mount|
	    type :smb
	    path 'smb://__USERNAME__:__PASSWORD__@c206.hsr.ch/skripte'
	  end
  
	  # One-way-mirroring of specified folders
	  one_way :server_to_local do |one_way|
	    one_way.source_base ':hsrscripts/Informatik/Fachbereich'
	    one_way.target_base local_path
	    one_way.mirror      'Betriebssystemkonzepte/BsKon', 'BsKon/Skripteserver'
	    one_way.mirror      'Datenbanksysteme_2/Dbs2',      'Datenbanksysteme_2/Dbs2'
	    one_way.mirror      'Software-Engineering_3/SE3',   'SE3/Skripteserver'
	    one_way.mirror      'Verteilte_SW-Systeme/Vss',     'Vss/Skripteserver'
	    exclude             'Thumbs.db'
	  end
  
	  # Mirror to dropbox folder:
	  one_way :dropbox do |one_way|
	    one_way.mirror      local_path, dropbox_path
	  end
  
	  # Unmount share:
	  unmount :hsrscripts
  
	end
	
Afterwards, invoke the `hsrhelpers sync` command and pass your job file:

	hsrhelpers sync myjobfile				# if in same directory
	hsrhelpers sync /path/to/myjobfile.rb	# if calling from somewhere else
