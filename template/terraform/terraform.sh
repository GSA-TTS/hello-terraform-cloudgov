#!/usr/bin/env bash

cmd="plan"

usage="
$0: Run terraform commands against a given environment

Usage:
  $0 -h
  $0 -e <ENV NAME> [-f] [-c <TERRAFORM-CMD>] [-- <EXTRA CMD ARGUMENTS>]

Options:
-h: show help and exit
-e ENV_NAME: The name of the environment to run terraform against
-f: Force, pass -auto-approve to all invocations of terraform
-c TERRAFORM-CMD: command to run. Defaults to $cmd
[<EXTRA CMD ARGUMENTS>]: arguments to pass as-is to terraform
"

env=""
force=""
args_to_shift=0

set -e
while getopts ":he:fc:" opt; do
  case "$opt" in
    e)
      env=${OPTARG}
      args_to_shift=$((args_to_shift + 2))
      ;;
    k)
      rmk=${OPTARG}
      args_to_shift=$((args_to_shift + 2))
      ;;
    f)
      force="-auto-approve"
      args_to_shift=$((args_to_shift + 1))
      ;;
    c)
      cmd=${OPTARG}
      args_to_shift=$((args_to_shift + 2))
      ;;
    h)
      echo "$usage"
      exit 0
      ;;
  esac
done

shift $args_to_shift
if [[ "$1" = "--" ]]; then
  shift 1
fi

if [[ -z "$env" ]]; then
  echo "-e <ENV_NAME> is required"
  echo "$usage"
  exit 1
fi

if [[ ! -f "$env.tfvars" ]]; then
  echo "$env.tfvars file is missing. Create it first"
  exit 1
fi

# ensure we're logged in via cli
cf orgs &> /dev/null || cf login -a api.fr.cloud.gov --sso

tfm_needs_init=true
if [[ -f .terraform/terraform.tfstate ]]; then
  backend_state_env=`cat .terraform/terraform.tfstate | jq -r ".backend.config.key" | cut -d '.' -f3`
  if [[ "$backend_state_env" = "$env" ]]; then
    tfm_needs_init=false
  fi
fi

if [[ $tfm_needs_init = true ]]; then
  if [[ ! -f secrets.backend.tfvars ]]; then
    echo "=============================================================================================================="
    echo "= Recreating backend config file. It is fine if this step wants to delete any local_sensitive_file resources"
    echo "=============================================================================================================="
    (cd bootstrap && ./apply.sh -auto-approve)
  fi
  terraform init -backend-config=secrets.backend.tfvars -backend-config="key=terraform.tfstate.$env" -reconfigure
  rm secrets.backend.tfvars
fi

echo "=============================================================================================================="
echo "= Calling $cmd $force on the application infrastructure"
echo "=============================================================================================================="
terraform "$cmd" -var-file="$env.tfvars" $force "$@"
