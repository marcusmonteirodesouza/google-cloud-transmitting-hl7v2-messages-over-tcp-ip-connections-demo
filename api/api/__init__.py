import logging
import sys
from fastapi import FastAPI
from googleapiclient import discovery
from .config import config

logging.basicConfig(stream=sys.stdout, level=logging.INFO)

healthcare_v1_client = discovery.build(serviceName="healthcare", version="v1")

app = FastAPI()


@app.get("/healthz")
async def health_check():
    return {}


@app.get("/")
async def list_hl7v2_messages():
    hl7v2_messages_parent = "projects/{}/locations/{}/datasets/{}".format(
        config.GOOGLE_CLOUD_PROJECT,
        config.HL7V2_DATASET_LOCATION,
        config.HL7V2_DATASET_NAME,
    )
    hl7v2_message_path = "{}/hl7V2Stores/{}".format(
        hl7v2_messages_parent, config.HL7V2_STORE_NAME
    )

    hl7v2_messages = (
        healthcare_v1_client.projects()
        .locations()
        .datasets()
        .hl7V2Stores()
        .messages()
        .list(parent=hl7v2_message_path)
        .execute()
        .get("hl7V2Messages", [])
    )

    return hl7v2_messages


@app.get("/{hl7v2_message_id}")
async def get_hl7v2_message(hl7v2_message_id: str):
    hl7v2_parent = f"projects/{config.GOOGLE_CLOUD_PROJECT}/locations/{config.HL7V2_DATASET_LOCATION}"
    hl7v2_message_name = "{}/datasets/{}/hl7V2Stores/{}/messages/{}".format(
        hl7v2_parent,
        config.HL7V2_DATASET_NAME,
        config.HL7V2_STORE_NAME,
        hl7v2_message_id,
    )

    msgs = (
        healthcare_v1_client.projects().locations().datasets().hl7V2Stores().messages()
    )
    message = msgs.get(name=hl7v2_message_name).execute()

    return message
