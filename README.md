# mcmgr
A bash script to help with managing custom minecraft servers!


Installation (will be set up properly in the future):
-------------
    1. Clone the repo or download the install.sh
    2. Navigate to where the install.sh is located
    3. Run 'sh ./install.sh'

Usage:
-------------
To use this script you must first configure it correctly.
For now, the configuration file is not implemented, so to configure the script you will have to edit the script itself.
First open 'minecraft-manager.sh' in your preffered editor. At the top you will see a few variables declared.

<h3>Here they are in order:</h3>

| Option      | Default value | Explenation      |
| ------------- | ------------- | ------------- |
| configPath= | "./mcmgr.config" | As of right now, this option does nothing. |
| minecraftPath= | "/home/$USER/minecraft/" | This is the path to your minecraft directory. This is where the mods, world and other folders are stored. By defualt the script assumes your minecraft directory is in in your home directory. |
| minecraftJarCommand= | "java -jar $minecraftPath""server.jar nogui" | This option sets which command is used to run the server jar file. If you want to change the RAM paramaters, look it up on google. If you already have your own command, paste it in here, but replace the name of the server jar file with $minecraftPath. Eg. if your server jar is named "fabric-server.jar" and you want to run the server with 8GB of ram, you would set the option to: "java -Xmx8192M -Xms8192M -jar $minecraftPath""fabric-server.jar nogui"|
| tmuxMode= | "false" | This tells the script if it should use tmux to run the minecraft server in. Using tmux allows for stopping, restarting and hooking into the console from mcmgr. |
| tmuxSession= | "minecraft-session" | This tells the script what name it should assign to the tmux session when creating one. The default value works perfectly in most cases, but if you want to add your own automation scripts into the mix, take note of the value of this option |
| firstRun= | "true" | This tells the script if it's fine to run with the options that are currently set. If it is false, mcmgr will always exit with a message to check your config of mcmgr and to set this option to "true" |

Once configured properly, this script has a few usage arguments. Here's a list and explanation of what each option does:

| Argument | Explenation |
| -------- | ----------- |
| -e , --enable   | This argument is supposed to enable mcmgr to run, but because the config file is not implemented, this option doesn't do anything either |
| -r, --run | This option runs the server with the configured directory and java command |
| -s, --stop | This option stops the server |
| -re, --restart | This option restarts the server, giving the players a 10 second countdown |
| -t, --tmux-session | Add this option when running, stopping or restarting the server to specify which tmux session is affected |
| -j, --custom-jar | Specify the name of the jar to be used for future starts of the server. DOES NOT WORK YET |

