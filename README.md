# nginx-reverse-proxy-1-container
Bash generator of docker-compose.yml It'll ask you the domains you want include.
Be carefully because it removes the named.conf file and create a basic one with the zones for the domains
In one container is configured with volumes for every domain.
At the moment no mysql services is running. In the future I'll add it.
