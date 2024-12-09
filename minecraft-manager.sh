#!/bin/bash

configPath="/home/$USER/.config/mcmgr/mcmgr.config"

# Config path used for testing
#configPath="./mcmgr.config"

minecraftPath="/home/$USER/minecraft/"
minecraftJarCommand="java -jar $minecraftPath""server.jar nogui"

modsPath="${minecraftPath}mods/"

tmuxMode="true"
tmuxSession="minecraft-session"

firstRun="false"


#if [ ! -f "$configPath" ]; then
#    echo "Config file not found. Please re-install or open an issue on github if the problem persists"
#    exit 1
#fi

#while IFS='=' read -r key value; do
#    if [[ "$key"]]

if [ "$1" != "-e" ] && [ "$1" != "--enable" ] && [ $firstRun = "true" ]; then
    echo -e "First time run detected.\nPlease check the configuration: (can be changed in $configPath, or with command arguments) \n"
    echo "Path to the minecraft directory: $minecraftPath"
    echo "Java command to run the server: $minecraftJarCommand"
    echo "tmux mode: $tmuxMode"
    echo "tmux session name to start the server in: $tmuxSession"

    echo -e "\nTo enable mcmgr and hide this message run 'mcmgr -e' or 'mcmgr --enable'"
else
    case $1 in
        "-c" | "--command")
            if [ -z "$2" ]; then
                echo "No command to run in the server cosnole was provided"
            else
                tmux send-keys -t "$miecraftSession" "$2" C-m
                if [ "$3" == "-k" ] || [ "$3" == "--keep" ]; then
                    tmux attach -t "$minecraftSession"
                else
                    if [ -n "$3" ]; then
                        echo "Unknown argument""$3"" . To stay in your shell and not show the minecraft console output, add -k or --keep here. Otherwise, only the command is needed."
                    fi
                fi
			fi
    	;;
        "-m" | "--download-mod")
            if [ "$2" = "" ]; then
                echo "No link to mod provided"
            else
                if [[ "$2" != *"/"*".jar"* ]]; then
                    echo "The url provided doesn't seem to point to a jar file. See mcmgr -h or mcmgr --help for an example url"
                else
                    pastWorkingDirectory="$PWD"
                    echo "Downloading mod to $modsPath"
                    cd "$modsPath" && wget "$2"
                    cd "$pastWorkingDirectory"
                fi
            fi
        ;;
        "-e" | "--enable")
            echo "Enableing not implemented yet, to enable mcmgr, configure the script and set firstRun to 'true'"
            #this dont work :(
            #echo "ill try tho"
            #firstRun="false"
        ;;
        "--run" | "-r")

            if [ "$tmuxMode" = "true" ] && [ "$2" = "-t" ] || [ "$2" = "--tmux-session" ] && [ "$3" != ""]; then
                tmuxSession="$3"
            fi


            if [ "$tmuxMode" = "true" ]; then
                tmux new-session -d -s $tmuxSession 
				tmux send-keys -t $tmuxSession "cd $minecraftPath && $minecraftJarCommand" C-m
				echo "Started minecraft server in new tmux session: $tmuxSession"
                echo "To interact with the console run 'tmux attach -t $tmuxSession or connect to your server via RCON"
            else
                exec $minecraftJarCommand
            fi
        ;;
        "--stop" | "-s")
            if [ "$tmuxMode" = "true" ]; then
                tmux send-keys -t $tmuxSession 'stop' C-m
                echo "Stopped the server and closed the $tmuxSession tmux session"
            else
                echo "Stopping is not supported without tmux mode"
            fi
        ;;
        "--restart" | "-re")
            if [ "$tmuxMode" = "true" ]; then

                if [ "$2" = "-t" ] || [ "$2" = "--tmux-session" ] && [ "$3" != ""]; then
                    tmuxSession="$3"
                fi

                for ((i = 0; i < 10; i++));
                    do 
                        echo "The server is restarting in " $((10 - $i)) " seconds..."
                        sleep 1;
                    done
                tmux send-keys -t $tmuxSession 'stop' C-m
                echo "Restarting server now."
                sleep 2
                tmux new-session -d -s $tmuxSession
				tmux send-keys -t $tmuxSession "cd $minecraftPath && $minecraftJarCommand" C-m
            else
                echo "Restarting is not supported without tmux mode"
            fi    
        ;;
        "--custom-jar" | -j)
            if [ $2 != "" ]; then
                $minecraftJarCommand = $2
            else
                echo "No command for the server jar was provided!"
            fi
        ;;
        "")
            echo "No arguments provided."
        ;;
        *)
            echo "Unknown argument: " $1
            echo "For proper usage see 'mcctrl -h' or 'mcmgr --help' (jk lmao, i didnt implement that yet)"
        ;;
    esac
fi
