# Windows Subsystem for Linux specific stuff

if [ -n "${WSL_DISTRO_NAME}" ]; then

  #export DISPLAY=${HOST}.local:0.0
  export DISPLAY="$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0.0"
  export LIBGL_ALWAYS_INDIRECT=1

  # Some command line tools (podman login) use the location defined in XDG_RUNTIME_DIR to store some data
  # by default in WSL the variable is not defined, so some tools might default to store the data in /tmp
  # of they just might error out. If they error out, you might want to uncomment the following two lines
  # export XDG_RUNTIME_DIR="${HOME}/.xdg/"
  # [ -d "${XDG_RUNTIME_DIR}" ] || mkdir -p "${XDG_RUNTIME_DIR}"

  # Function to resolve Windows variables. Removes the CR windows binaries spit out
  get_win_var () { cmd.exe /c "echo ${1}" 2> /dev/null | sed -e 's/\r//g'; }

  wslshutdown () { cmd.exe /C wsl --shutdown -d ${WSL_DISTRO_NAME}; }

  ### Workarounds for the lack of SYSTEMD support in Microsoft's WSL distros

  # Since systemd is not enabled in WSL2, we need to start any services manually
  services=( docker cron )
  for service in "${services[@]}"; do
    sudo service "${service}" status >/dev/null 2>&1 || sudo service "${service}" start
  done

  # This solves issues with docker/podman containers that rely on systemd
  [ -d "/sys/fs/cgroup/systemd" ] || sudo mkdir "/sys/fs/cgroup/systemd"
  mount | grep 'name=systemd' || sudo mount -t cgroup -o none,name=systemd cgroup /sys/fs/cgroup/systemd

fi
