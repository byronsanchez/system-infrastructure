#!/bin/sh
#
# Certificate authority management script
#
# Recommended valid days
# root - 7205
# user - 1095
# system - 1109

source /usr/local/lib/nitelite/helpers/common.lib.sh;

WORKDIR="/etc/ssl"

# Initialize our own variables:
parent=""
output=""
valid=""

action=""

root_name=""
child_name=""
request_output_name=""
request_input_name=""
revoke_name=""
exp_name=""

quiet=0

############################
# Argument Parsing Functions

# TODO: validate action values

# REVOKE
# the cert to revoke

function show_help ()
{
cat <<-EOM

$0 [OPTION] command

options:

    -p --parent=NAME         Use <parent> as the parent key value
    -o --output=FILE         The name to give generated files
    -v --valid=DAYS          Number of days that the certificate is valid

commands:

    -r --create-root=NAME              Create a root CA key
    -c --create-child=NAME             Create a child CA key
    -s --sign-request=NAME             Sign a certificate request
    -R --create-request=NAME           Create a key and signing request
    -x --revoke=NAME                   Revoke a key
    -l --list-expirations=NAME         List exp dates of certs signed by a CA

other:

    -q --quiet               do not log messages to STDOUT
    -h --help                display this message

EOM
    exit 1
}

function get_options () {
    argv=()
    while [ $# -gt 0 ]
    do
        opt=$1
        shift
        case ${opt} in
            -p|--parent)
                parent=$1
                shift
                ;;
            --parent=*)
                parent=$(echo ${opt} | cut -d'=' -f 2);
                ;;
            -o|--output)
                output=$1
                shift
                ;;
            --output=*)
                output=$(echo ${opt} | cut -d'=' -f 2);
                ;;
            -v|--valid)
                valid=$1
                shift
                ;;
            --valid=*)
                valid=$(echo ${opt} | cut -d'=' -f 2);
                ;;

            -r|--create-root)
                root_name=$1
                action="create-root"
                shift
                ;;
            --create-root=*)
                root_name=$(echo ${opt} | cut -d'=' -f 2);
                action="create-root"
                ;;
            -c|--create-child)
                child_name=$1
                action="create-child"
                shift
                ;;
            --create-child=*)
                child_name=$(echo ${opt} | cut -d'=' -f 2);
                action="create-child"
                ;;
            -s|--sign-request)
                request_input_name=$1
                action="sign-request"
                shift
                ;;
            --sign-request=*)
                request_input_name=$(echo ${opt} | cut -d'=' -f 2);
                action="sign-request"
                ;;
            -R|--create-request)
                request_output_name=$1
                action="create-request"
                shift
                ;;
            --create-request=*)
                request_output_name=$(echo ${opt} | cut -d'=' -f 2);
                action="create-request"
                ;;
            -x|--revoke)
                revoke_name=$1
                action="revoke"
                shift
                ;;
            --revoke=*)
                revoke_name=$(echo ${opt} | cut -d'=' -f 2);
                action="revoke"
                ;;
            -l|--list-expirations)
                exp_name=$1
                action="list-expirations"
                shift
                ;;
            --list-expirations=*)
                exp_name=$(echo ${opt} | cut -d'=' -f 2);
                action="list-expirations"
                ;;

            -q|--quiet)
                quiet=1
                ;;
            -h|--help)
                show_help
                ;;
            *)
                if [ "${opt:0:1}" = "-" ]; then
                    fail "${opt}: unknown option."
                fi
                argv+=(${opt})
                ;;
        esac
    done 
}

##################
# GLOBAL VALIDATION

# Parse options if they were passed
get_options $*

if [ ! -n "$action" ];
then
  fail "please provide a valid command to execute"
fi

#############
# MAIN SCRIPT

case "$action" in
create-root)

  info "creating root CA with name ${root_name}..."

  # default to 20 years
  if [ ! -n "$valid" ];
  then
    valid=7205
    warn "no valid amount of days set. defaulting to ${valid}..."
  fi

  # setup the root CA dir's directory structure
  # we need to start with the default cadir as defined in /etc/ssl/openssl.cnf
  default_cadir="${WORKDIR}/niteliteCA"
  target_cadir="${WORKDIR}/${root_name}"
  cakey="${default_cadir}/private/cakey.pem"

  mkdir -p "${default_cadir}"
  mkdir -p "${default_cadir}/crl"
  mkdir -p "${default_cadir}/newcerts"
  mkdir -p "${default_cadir}/private"

  # create root private key
  openssl genrsa -des3 -out ${cakey} 4096

  # create the certificate from the key
  openssl req -new -x509 -days ${valid} -key ${cakey} -out \
    ${default_cadir}/cacert.pem

  # create certificate recovation list
  touch ${default_cadir}/index.txt
  echo 01 > ${default_cadir}/crlnumber
  echo 01 > ${default_cadir}/serial

  # generate the cert revoc list
  openssl ca -gencrl -crldays 365 -keyfile ${cakey} -cert \
    ${default_cadir}/cacert.pem -out ${default_cadir}/crl.pem

  mv ${default_cadir} "${target_cadir}"

  ;;

create-child)

  info "creating child CA with name ${child_name}..."

  if [ ! -n "$parent" ];
  then
    fail "please provide a valid parent CA"
  fi

  # default to 20 years
  if [ ! -n "$valid" ];
  then
    valid=7205
    warn "no valid amount of days set. defaulting to ${valid}..."
  fi

  # setup the root CA dir's directory structure
  cadir="${WORKDIR}/${child_name}"
  cakey="${cadir}/private/cakey.pem"

  mkdir -p "${cadir}"
  mkdir -p "${cadir}/crl"
  mkdir -p "${cadir}/newcerts"
  mkdir -p "${cadir}/private"

  # create child private key
  openssl genrsa -des3 -out ${cakey} 4096
  # create the unencrypted key file
  openssl rsa -in ${cakey} -out ${cakey}.unencrypted

  # generate a cert signing request from the child private key
  openssl req -new -days ${valid} -key ${cakey} -out ${cadir}/${child_name}.csr

  # create certificate recovation list
  touch ${cadir}/index.txt
  echo 01 > ${cadir}/crlnumber
  echo 01 > ${cadir}/serial

  # generate cert from the specified parent CA
  openssl ca -name ${parent} -days ${valid} -extensions v3_ca -out \
    ${cadir}/cacert.pem -infiles ${cadir}/${child_name}.csr

  ;;

create-request)

  info "creating request ${request_output_name}..."

  # create a key and csr
  #
  # create the encrypted key file
  openssl req -newkey rsa:4096 -keyout ${request_output_name}.key -out \
    ${request_output_name}.req
  # create the unencrypted key file
  openssl rsa -in ${request_output_name}.key -out \
    ${request_output_name}.key.unencrypted

  echo | mutt csr@systems.nitelite.io -s \
    "[nitelite.io] Certificate Signing Request" -a \
    ${request_output_name}.req

  ;;

sign-request)

  info "signing request ${request_input_name}..."

  if [ ! -n "$parent" ];
  then
    fail "please provide a valid parent CA"
  fi

  # default to 20 years
  if [ ! -n "$valid" ];
  then
    valid=7205
    warn "no valid amount of days set. defaulting to ${valid}..."
  fi

  # default to request_input_name for cert name
  if [ ! -n "$output" ];
  then
    output="${request_input_name}"
    warn "no output name supplied for cert file. defaulting to ${output}..."
  fi

  # infile is the csr, outfile is the crt
  openssl ca -name ${parent} -days ${valid} -out ${output} -infiles \
    ${request_input_name}

  # TODO: consider whether or not this is a good idea on a closed lan and the
  # associated risks in case I ever want to expose any nodes publically
  #mutt -s "[nitelite.io] Certificate Signing Request Approved" -a \
  #  ${output} csr@vega.internal.nitelite.io

  ;;

revoke)

  # the revoke arg (x) is the fqdn field used to identify identity
  # eg. root has niteLite Root CA. grep for this and revoke as necessary
  info "revoking certificate with name ${child_name}..."

  if [ ! -n "$parent" ];
  then
    fail "please provide a valid parent CA"
  fi

  cadir="${WORKDIR}/${parent}"

  # First, find this users' (signed) certificate. Look at the index.txt file
  # within the CA directory to find out what number the certificate has
  revoke_line=$(grep -i ${revoke_name} ${cadir}/index.txt | tail -1);
  revoke_number=$(echo $revoke_line | awk '{print $3}' )

  # then use this number for the revocation:
  openssl ca -name ${parent} -revoke ${cadir}/newcerts/${revoke_number}.pem

  # Next, publish the new certificate revocation list
  #
  # TODO:
  # The resulting certificate revocation list then needs to be published where all
  # users can find it. (ocsp?)
  openssl ca -name ${parent} -gencrl -out ${cadir}/crl/${parent}.crl

  ;;

list-expirations)

  cadir="${WORKDIR}/${exp_name}"

  info "listing expiration dates of certificates signed by CA ${exp_name}"

  for f in $cadir/newcerts/*
  do
    openssl x509 -noout -subject -enddate -in $f
  done

  ;;

*)
  fail "${action}: unknown command."
  ;;
esac

