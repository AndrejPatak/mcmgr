#include <iostream>
#include <string>
#include <cstdlib>
#include <fstream>
#include <map>

using std::cout, std::cin, std::string, std::endl, std::system, std::ifstream, std::ofstream, std::map, std::getline;

string user = getenv("USER");

string minecraftPath = "/home/" + user + "/minecraft/";

map<string, string> params = { 
	{"configPath", "./mcmgr.config"},
	{"minecraftPath", "/home/" + user + "/minecraft/"},
	{"minecraftJarCommand", "java -jar " + minecraftPath + "server.jar nogui"},
	{"modsPath", minecraftPath + "mods/"},
	{"tmuxSession", "minecraft-session"},
	{"tmuxMode", "true"},
	{"firstRun", "true"}
};

string configPath = params["configPath"];

bool checkConfig(){

	ifstream cfg(configPath);
	
	if(!cfg.is_open())
		cout << "Config file not found...";
	return cfg.is_open();
}

void makeConfig(){
	
	cout << "Making new config file at: " << configPath << endl;
	
	ofstream cfg_out(configPath);
	ifstream cfg_in(configPath);

	if(cfg_in.is_open()){
		cout << "Config made successfully. " << endl;
	}else{
		cout << "Failed to make config file. If this issue persists report the error.";
	}

}

void resetConfig(){
	ifstream cfg_in(configPath);
	if(cfg_in.is_open()){
		ofstream cfg_out(configPath);
		cfg_out << "minecraftPath=/home/" << user << "/minecraft/" << endl;
		cfg_out << "minecraftJarCommand=" << "java -jar " + minecraftPath + "server.jar nogui" << endl;
		cfg_out << "modsPath=/home/" << user << "/minecraft/mods/" << endl;
		cfg_out << "tmuxMode=false" << endl;
		cfg_out << "tmuxSession=minecraft-session" << endl;
		cfg_out << "firstRun=" << params["firstRun"] << endl;
	}else{
		cout << "Tried resetting config file but it wasn't found in ";
		cout << configPath << endl;

		makeConfig();
	}
}

void readAndSetConfig(){
	ifstream cfg_in(configPath);
	
	string line;
	while(getline(cfg_in, line, '=')){
		string value;
		getline(cfg_in, value);
		cout << line << ": " << value << endl;
	}

}


int main(int argc, char *argv[]){

	bool firstRun;
	bool tmuxMode;

	string *args = new string[argc];

	for(int i = 0; i < argc; i++){
		args[i] = argv[i];
	//	cout << "Argument " << i + 1 << ". is: " << args[i] << endl;
	}

	readAndSetConfig();

	if (args[1] != "-e" && args[1] != "--enable" && firstRun == true){
		cout << "First time run detected.\nPlease check the configuration: (can be changed in '" + configPath + "', or with command arguments) \n";


	}else{
		if(args[1] == "-e" || args[1] == "--enable"){
			int checkCounter = 0;
			while(!checkConfig() && checkCounter < 5){
				makeConfig();
				checkCounter++;
			}
			if(checkConfig()){
				resetConfig();
			}
		}else if(args[1] == "-r" || args[1] == "--run"){
			if(params["tmuxMode"] == "true"){
				string session;
				if(args[2] == "-t" || args[2] == "--tmux-session"){
					session = args[3];
				}else{
					session = params["tmuxSession"];
				}
					string command = "tmux new-session -d -s " + session;
					system(command.c_str());
					cout << "Ran: " << command << endl;	
					command = "tmux send-keys -t " + session + " \"" +"cd " + params["minecraftPath"] + " && " + params["minecraftJarCommand"] + "\"" + " C-m";
					system(command.c_str());
			}else{
				system(("exec " + params["minecraftJarCommand"]).c_str());	
			}
		}
	}

	delete[] args;
}
