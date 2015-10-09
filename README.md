# Steve, a build agent
For another project I needed a very simple CI tool that would be triggered by a post-receive hook in my remote Git repository.
I started out with calling a script directly from that hook but that causes the push to block untill the script has completed instead of a fire-and-forget.

Steve is a Bash script that runs every minute as a Cron job and looks in a queue for new requests. A request is a file that contains:

```
file:////home/joe-bob/Repositories/SomeProject.git
480b39a77acaaa3484892b07808e12cbb177f08e
```
First line is the path to the repository (can be a remote one), second line is the commit hash.

Steve looks for these files in /var/spool/steve (default config) and will execute them one at a time. If a previous Steve script is still running because a build might take more than 1 minute Steve will exit and not try to compete for pending requests.

Steve can be configured to send a notification when a request fails or succeeds using Prowl for example. To enable this set NOTIFIER in your steve.conf to a script that accepts the following arguments (in order):

* Application
* Priority
* Event
* Description

## Word of warning
This works for me, YMMV

## Configuring your repository for Steve
In your remote repository change (or add to) your post-receive hook to:

```
#!/bin/sh

REQUEST=`date +%Y%m%d%H%M%S`.request

while read oldvalue newvalue refname
do
  echo "file:///$PWD" > /var/spool/steve/$REQUEST
  echo "$newvalue" >> /var/spool/steve/$REQUEST
done
```
Or just copy the post-receive.template to your hooks folder.

## Contributing
If you want to hack Steve have a look at the test folder. To add new behaviour or modify existing behaviour please add a test first. See the README.md in the test folder for details.

Steve was created by Sander van Vliet (@Codenizer)