#!/bin/bash
set -u
set -e
set -x


previous_account=`gcloud auth list | grep "^\* " | awk '{print $2;}'` 2>/dev/null
gcloud config set account speech-to-text@speech-api-173412.iam.gserviceaccount.com

for input_path in $@
do
    if [ "${input_path: -4}" == ".mp3" ]
    then
        to_upload=${input_path}.flac
        ffmpeg -i ${input_path} -ac 1 -y $to_upload
    else
        to_upload=${input_path}
    fi

    echo $to_upload
    gsutil cp $to_upload gs://com_mezhaka_input_audio

    structured_output="structured.${to_upload}.txt"
    gcloud ml speech recognize-long-running "gs://com_mezhaka_input_audio/${to_upload}" --language-code=ru-RU > $structured_output
    cat $structured_output | jq '.results[].alternatives[].transcript' > "removed-structure.${to_upload}.txt"
done

gcloud config set account $previous_account
