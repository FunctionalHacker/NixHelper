<h1>NixHelper</h1>
<h4>A bash script that fetches command aliases from a web server</h4>
NixHelper is here to help you remember long and obscure *nix commands!<br><br>

It's a very simple program by desing, it simply checks the root of a predefined web-server to see if there is a command matching your alias. The host that NixHelper binds to by default, is no means the only one. You could easily host an alias server of your own. The only thing you would need to change is the 'host' variable at the top of the script and it should start working with your own server. In the server side, you just need to create a simple webpage with Apache or NGINX and place your aliases as basic text files in the webroot. Name the alias files as the names you would like to use them in NixHelper and you're good to go!

This is a good solution for those of you who use a lot of aliases on multiple machines. If you also happen to have a web-server, you can just save all of your aliases there and manage them from a single place. Beware that the aliases are readable by anyone so don't store anything confidential. If you would like for me to start working on a secure version of NixHelper, open up an issue with your ideas. I've already thought of adding a key-based authentication method.

There's no limit on the size of the command, so you could even host full sized Bash scripts using this script!
Below is an example of my workflow with NixHelper:

<a href="https://asciinema.org/a/nTxDSuvr5L6TdzAGmHmUSEAXF" target="_blank"><img src="https://asciinema.org/a/nTxDSuvr5L6TdzAGmHmUSEAXF.png" /></a>
