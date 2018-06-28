#!/usr/bin/env bash

USER="${1}"
COMMENT="${1} user on Vagrant for demo"
GROUP="${1}"
HOME="/srv/${1}"

YUM=$(which yum 2>/dev/null)
APT_GET=$(which apt-get 2>/dev/null)

user_rhel() {
  sudo /usr/sbin/groupadd --force --system ${GROUP}

  if ! getent passwd ${USER} >/dev/null ; then
    sudo /usr/sbin/adduser \
      --system \
      --gid ${GROUP} \
      --home ${HOME} \
      --no-create-home \
      --comment "${COMMENT}" \
      --shell /bin/false \
      ${USER}  >/dev/null
  fi
}

user_deb() {
    ##  Debian user
  if ! getent group ${GROUP} >/dev/null
  then
    sudo addgroup --system ${GROUP} >/dev/null
  fi

  if ! getent passwd ${USER} >/dev/null
  then
    sudo adduser \
      --system \
      --disabled-login \
      --ingroup ${GROUP} \
      --home ${HOME} \
      --no-create-home \
      --gecos "${COMMENT}" \
      --shell /bin/false \
      ${USER}  >/dev/null
  fi
}

if [[ ! -z ${YUM} ]]; then
  user_rhel
elif [[ ! -z ${APT_GET} ]]; then
  user_deb
else
  echo "ERROR"
  exit 1;
fi
