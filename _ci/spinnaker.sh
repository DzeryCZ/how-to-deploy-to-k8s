#!/bin/sh

set -e

doRequest ()
{
    local urlEndpoint=$1
    local method=$2
    local data=$3

    local response=$(curl --silent --show-error --user $SPINNAKER_USER:$SPINNAKER_PASSWORD --header 'Accept: application/json' -H 'content-type:application/json' $SPINNAKER_BASE_URL$urlEndpoint -X $method -d $data)

    if [[ "$?" != "0" || "$response" = "" ]]; then
        >&2 echo "$response"
        >&2 echo "FAILED"
        exit 1
    fi

    echo "$response"
}

echo
echo "--------------------------------------------------"
echo "Application: $SPINNAKER_APPLICATION_NAME"
echo "Pipeline: $SPINNAKER_PIPELINE_NAME"
echo "Version: $CI_PIPELINE_ID"
echo "--------------------------------------------------"
echo

pipelineInfo=$(doRequest "/pipelines/$SPINNAKER_APPLICATION_NAME/$SPINNAKER_PIPELINE_NAME" "POST" "{\"parameters\":{\"version\":\"$CI_PIPELINE_ID\"}}")
error=$(echo $pipelineInfo | jq .message) # Output error message, in case of failure
pipelineId=$(echo $pipelineInfo | jq .ref | cut -d'"' -f 2)

if [[ "$error" != "null" ]]; then
    echo "Error: $error"
    exit 1
fi

echo "Pipeline triggered. Endpoint: $pipelineId"

# Below this it's experimental functionality. If it massively block pipeline, we'll have to come with another solution.

counter=0
pipelineInfo=$(doRequest "$pipelineId" "GET" "{}")
error=$(echo $pipelineInfo | jq .message) # Output error message, in case of failure
pipelineStatus=$(echo $pipelineInfo | jq .status)
echo "Status: $pipelineStatus [$counter]"

if [[ "$error" != "null" ]]; then
    echo "Error: $error"
    exit 1
fi

while [[ "$pipelineStatus" = "\"RUNNING\"" || "$pipelineStatus" = "\"NOT_STARTED\"" ]]; do

    sleep 5
    let counter=counter+1
    # wait for max 10 minutes
    if [[ $counter -gt 120 ]]; then
        echo "TIMEOUT"
        exit 1
    fi

    pipelineInfo=$(doRequest "$pipelineId" "GET" "{}")
    error=$(echo $pipelineInfo | jq .message) # Output error message, in case of failure
    pipelineStatus=$(echo $pipelineInfo | jq .status)
    echo "Status: $pipelineStatus [$counter]"

    if [[ "$error" != "null" ]]; then
        echo "Error: $error"
        exit 1
    fi

done

if [[ "$pipelineStatus" != "\"SUCCEEDED\"" ]]; then
    echo "Error. Check the Spinnaker pipeline."
    exit 1
fi

echo "DONE"