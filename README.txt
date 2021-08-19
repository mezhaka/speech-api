gcloud auth activate-service-account --key-file speech-api-173412-87a9b1c8bb4e.json

Cloud storage -> Browser -> bucket permissions -> Add service account, give
"Storage Object Creator"
"Storage Object Viewer"
role.  If we want to be able to overwrite files, then we also need a
"Storage Object Admin"
role.

merge channels from a stereo mp3:
ffmpeg -i krashenikov-ruaudio0423.mp3 -ac 1  recognize-me.flac

upload to bucket
env GOOGLE_APPLICATION_CREDENTIALS=/Users/ant/t/speech_api/speech-api-173412-87a9b1c8bb4e.json gsutil cp recognize-me.flac gs://com_mezhaka_input_audio

transcribe:
env GOOGLE_APPLICATION_CREDENTIALS=/Users/ant/t/speech_api/speech-api-173412-87a9b1c8bb4e.json gcloud ml speech recognize-long-running gs://com_mezhaka_input_audio/recognize-me.flac --language-code=ru-RU   > structured.txt
cat structured.txt | jq '.results[].alternatives[].transcript' > removed-structure.txt

transcirbe async:
env GOOGLE_APPLICATION_CREDENTIALS=/Users/ant/t/speech_api/speech-api-173412-87a9b1c8bb4e.json gcloud ml speech recognize-long-running --async  gs://com_mezhaka_input_audio/recognize-me.flac --language-code=ru-RU   > operation_id.json
gcloud ml speech operations describe OPERATION_ID > structured.json
cat structured.json | jq '.response.results[].alternatives[].transcript' > removed-structure.txt


Usually I get a problem accessing othoz stuff after I activate my own service
account and it helps to do (maybe delete my service account first):
gcloud container clusters get-credentials othoz-cluster --zone europe-west3-b --project lofty-seer-161814

