# !/bin/bash

# Set default json

default_json=$(cat <<-END
{
    "duration": 10,
    "randomize": "true"
}
END
)

additional_args=""

# If the slideshow directory doesn't exist - create it
if ! [ -d /slideshow ]; then
    mkdir /slideshow
fi

# If settings.json doesnt exist - create settings.json
if ! [ -f /slideshow/settings.json ]; then
    echo $default_json >> /slideshow/settings.json
fi

# If slides.txt doesnt exist - create image + slides.txt
if ! [ -f /slideshow/slides.txt ]; then
    create_info_image
    echo /slideshow/info.jpg >> /slideshow/slides.txt
fi

duration=$(jq -r .duration /slideshow/settings.json)
if [ $(jq -r .randomize /slideshow/settings.json) == "true" ]; then
    additional_args=" --randomize ${additional_args}"
fi

feh \
--auto-zoom \
--fullscreen \
--no-menus \
--slideshow-delay ${duration} \
--filelist /slideshow/slides.txt \
${additional_args}

function create_info_image () {
    # $1 - text
    convert -size 1000x1000 xc:black +repage \
    -size 800x800  -fill white -background None  \
    -font CourierNewB -gravity center caption:"$(hostname) - $(hostname -I)\nConfigure images using admin dashboard" +repage \
    -gravity Center  -composite -strip  /slideshow/info.jpg
}