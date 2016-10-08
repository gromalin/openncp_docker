#Change to your company details
country=FR
state=Paris
locality=Paris
organization="Ministere de la Sante"
organizationalunit=DSSIS
email=thomas.david@sante.gouv.fr
commonname=openncp.sante.gouv.fr

password=rootroot

mkdir -p ROOT
country="fr"
openssl genrsa -des3 -out ROOT/$country-ca.key  -passout pass:$password 4096
openssl req -new -x509 -days 3650 -key ROOT/$country-ca.key -out ROOT/$country-ca.pem -passin pass:$password -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
