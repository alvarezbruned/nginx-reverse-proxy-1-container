#!/bin/bash
echo 'Write the number of domains you will generate and press ENTER'
read I

OUTFILE2='default2.conf'
OUTFILE3='3prooffile.sh'
OUTFILE4='docker-compose.yml'
OUTFILE5='configdefault.conf'
rm $OUTFILE4
rm ./web/config/$OUTFILE5
rm ./web/config/default.conf
ITERATION='1'
PORT='8081'
mkdir web nginx web/html nginx/config
mkdir web/config
  echo 'websites:' >> $OUTFILE4
  echo '    image: albertalvarezbruned/webnginx' >> $OUTFILE4
  echo '    expose:' >> $OUTFILE4
J=$I
while [ "$J" -ne 0 ]
do
  echo '            - "'$PORT'"' >> $OUTFILE4
  let J-=1
  let PORT+=1
done
PORT='8081'
  echo '    volumes:' >> $OUTFILE4
  echo '        - ./logs/:/var/log/nginx/' >> $OUTFILE4
  echo '        - ./web/config/default.conf:/etc/nginx/conf.d/default.conf' >> $OUTFILE4
while [ "$I" -ne 0 ]
do
  mkdir web/html/site$ITERATION
  echo 'Give me the domain name '$ITERATION' and press ENTER'
  read DOMAI
  DOMAIN=`echo ${DOMAI,,}`
  # use $DOMAIN para lower -> ${variable,,}
  MIN=`echo $DOMAIN | cut -d '.' -f 1`
  MINS=`echo ${MIN^^}`
  MINSLOW=`echo ${MINS,,}`
  echo '        - ./web/html/site'$ITERATION':/var/www/html/site'$ITERATION':ro' >> $OUTFILE4
  echo '# website_'$DOMAIN':'  >> $OUTFILE4
  echo 'server {' >> $OUTFILE5
  echo '    listen '$PORT';' >> $OUTFILE5
  echo '    server_name  _;' >> $OUTFILE5
  echo '    access_log  /var/log/nginx/project-webdev.access.log;' >> $OUTFILE5
  echo '    error_log  /var/log/nginx/project-webdev.error.log;' >> $OUTFILE5
  echo '    root   /var/www/html/site'$ITERATION';' >> $OUTFILE5
  echo '    index  index.html;' >> $OUTFILE5
  echo '}' >> $OUTFILE5
  `cat $OUTFILE5 >> ./web/config/default.conf`
  rm $OUTFILE5
  echo '        - website_'$DOMAIN':'$MINSLOW >> LINKS
  rm ./web/html/site$ITERATION/index.html
  touch ./web/html/site$ITERATION/index.html
  echo '<html><head><title>My '$DOMAIN'</title></head><body>This is example of '$DOMAIN'</body></html>' > ./web/html/site$ITERATION/index.html
  let ITERATION+=1
  let PORT+=1
  let I-=1
  echo 'ou yeah'
done
  echo 'nginx:' >> $OUTFILE4
  echo '    image: albertalvarezbruned/nginx' >> $OUTFILE4
  echo '    expose:' >> $OUTFILE4
  echo '        - "80"' >> $OUTFILE4
  echo '        - "443"' >> $OUTFILE4
  echo '    links:' >> $OUTFILE4
  echo '        - websites' >> $OUTFILE4
  echo '    ports:' >> $OUTFILE4
  echo '        - "80:80"' >> $OUTFILE4
  echo '    volumes:' >> $OUTFILE4
  echo '        - ./logs/:/var/log/nginx/' >> $OUTFILE4
  echo '        - ./nginx/config:/etc/nginx/conf.d' >> $OUTFILE4
rm $OUTFILE3
rm LINKS
docker-compose up -d
./nginx_gen.sh
