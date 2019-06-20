for script in ./scripts/demo*.sh; do
    filename="$(basename $script)"
    ./src/jb.sh -c ${filename%.*}
done
