#!/bin/bash
CONTAINER_ID=$1
docker inspect -f '{{ .Name }}{{ printf "\n" }}{{ range .Mounts }}{{ printf "\n\t" }}{{ .Type }} {{ if eq .Type "bind" }}{{ .Source }}{{ end }}{{ .Name }} => {{ .Destination }}{{ end }}{{ printf "\n" }}' $CONTAINER_ID
