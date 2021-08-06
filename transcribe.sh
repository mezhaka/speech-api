#!/bin/bash
set -u
set -e
set -x

previous_account=`gcloud auth list | grep "^\* " | awk '{print $2;}'` 2>/dev/null
gcloud config set account speech-to-text@speech-api-173412.iam.gserviceaccount.com

#input_path=$1
for input_path in $@
do
    echo $input_path
    gsutil cp $input_path gs://com_mezhaka_input_audio

    structured_output="structured.${input_path}.txt"
    gcloud ml speech recognize-long-running "gs://com_mezhaka_input_audio/${input_path}" --language-code=ru-RU > $structured_output
    cat $structured_output | jq '.results[].alternatives[].transcript' > "removed-structure${input_path}.txt"
done

gcloud config set account $previous_account
