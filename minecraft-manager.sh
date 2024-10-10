#!/bin/bash

#configPath="/home/$USER/.config/mcmgr/mcmgr.config"
configPath="./mcmgr.config"

minecraftPath="/home/$USER/minecraft/"
minecraftJarCommand="java -jar $minecraftPath""server.jar nogui"

modsPath="${minecraftPath}mods/"

tmuxMode="false"
tmuxSession="minecraft-session"

firstRun="false"


#if [ ! -f "$configPath" ]; then
#    echo "Config file not found. Please re-install or open an issue on github if the problem persists"
#    exit 1
#fi

#while IFS='=' read -r key value; do
#    if [[ "$key"]]

if  [ "$1" != "-e" ] && [ "$1" != "--enable" ] && [ $firstRun = "true" ]; then
    echo -e "First time run detected.\nPlease check the configuration: (can be changed in $configPath, or with command arguments) \n"
    echo "Path to the minecraft directory: $minecraftPath"
    echo "Java command to run the server: $minecraftJarCommand"
    echo "tmux mode: $tmuxMode"
    echo "tmux session name to start the server in: $tmuxSession"

    echo -e "\nTo enable mcmgr and hide this message run 'mcmgr -e' or 'mcmgr --enable'"
else
    case $1 in

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
            echo "Enableing not implremented yet, to enable mcmgr, configure the script and set firstRun to 'true'"
            #echo "ill try tho"
            #firstRun="false"
        ;;
        "--run" | "-r")

            if [ "$tmuxMode" = "true" ] && [ "$2" = "-t" ] || [ "$2" = "--tmux-session" ] && [ "$3" != ""]; then
                tmuxSession="$3"
            fi


            if [ "$tmuxMode" = "true" ]; then
                tmux new-session -d -s $tmuxSession "cd $minecraftPath && $minecraftJarCommand"
                echo "Started minecraft server in new tmux session: $tmuxSession"
                echo "To interact witht the console run 'tmux attach -t $tmuxSession or connect to your server via RCON"
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
                tmux new-session -d -s $tmuxSession "cd $minecraftPath && $minecraftJarCommand"
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