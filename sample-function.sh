#!/bin/bash

DEBIAN_DISTRIB=("ubuntu" "debian" "debian os" "debian ec2 os")

search1="one"
search2="debian"
echo "on fait le listing"
echo "=========================="
for i in "${DEBIAN_DISTRIB[@]}";
do
    echo "$i";
done
echo "=========================="


if in_array $search1 "${DEBIAN_DISTRIB[@]}"; then
        echo "in_array ${search1}"
else
    echo "in_array NOT ${search1}"
fi

if in_array $search2 "${DEBIAN_DISTRIB[@]}"; then
        echo "in_array ${search2}"
else
    echo "in_array NOT ${search2}"
fi



if [[ $(contains "${DEBIAN_DISTRIB[@]}" $search1) == "yes" ]]; then
    echo "contains ${search1}"
else
    echo "contains NOT ${search1}"
fi
if [[ $(contains "${DEBIAN_DISTRIB[@]}" $search2) == "yes" ]]; then
    echo "contains ${search2}"
else
    echo "contains NOT ${search2}"
fi
