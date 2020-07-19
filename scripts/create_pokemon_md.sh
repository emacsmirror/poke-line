#!/bin/bash
#
# Create Pokemon.md with lookup names
#

POKEMON_DATA_URL='https://raw.githubusercontent.com/RyanMillerC/poke-position-images/master/pokemon-data.json'

echo 'Downloading pokemon-data.json...'
curl -s "${POKEMON_DATA_URL}" -o pokemon-data.json

echo 'Creating Pokemon.md...'
cat > Pokemon.md <<EOF
<!-- This file is generated by ./scripts/create_pokemon_md.sh. DO NOT EDIT IT DIRECTLY -->

# Pokemon Images

This page contains images and lookup names for each Pokemon. Because some pokemon
have unique names with special characters, it's a good idea to validate the name
using this list if you run into issues setting poke-mode to a particular value.

## Pokemon List

EOF

get_pokemon_data() {
    index="${1}"
    pokemon_id=$(jq -r ".[${index}].id" pokemon-data.json)
    pokemon_name=$(jq -r ".[${index}].name" pokemon-data.json)
    pokemon_type=$(jq -r ".[${index}].type" pokemon-data.json)
    echo "* #${pokemon_id}: \`${pokemon_name}\`"
    printf "  * ![${pokemon_name}](/img/pokemon/${pokemon_name}.png)"
    for ((element_counter=0; element_counter<10; element_counter++)) ; do
      printf "![](/img/element/${pokemon_type}.png)"
    done
    echo ""
}

echo 'Adding data to Pokemon.md...'
number_of_pokemon=$(jq '. | length' pokemon-data.json)
for ((iterator=0; iterator<number_of_pokemon; iterator++)) ; do
    echo "Processing Pokemon $((iterator+1)) of $((number_of_pokemon+1))..."
    get_pokemon_data "${iterator}" >> Pokemon.md
done
echo '' >> Pokemon.md

echo 'Complete!'