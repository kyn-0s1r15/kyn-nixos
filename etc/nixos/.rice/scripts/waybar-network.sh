

  #!/bin/bash

  network=$(nmcli device wifi list | fzf | awk '{print $1}')
  echo "Selected network: $network"
	  nmcli device wifi connect "$network" --ask
