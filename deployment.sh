#this file gets copied to each node, and executed.
#it will copy out all the needed files from the repo as well


#name of the repo machine
repo="root@45.79.49.90"
sftpLocation="markus@45.79.49.90:/"

#install all the needed linux packages
sudo apt update
sudo apt install sshfs r-base r-base-core r-base-dev libopenblas-base parallel

#make some keys and put them on the repo
ssh-keygen -t rsa
ssh-copy-id $repo

scp root@45.79.49.90:/root/theFlow.sh .
scp root@45.79.49.90:/root/libraryInstalls.R
scp root@45.79.49.90:/root/theCalculation.R

mkdir /theData #make the needed directory for the sshfs mount
sshfs "$repo" /theData #mount the sftp drive to the folder 'theData'

#install the needed R packages
Rscripts libraryInstalls.R
