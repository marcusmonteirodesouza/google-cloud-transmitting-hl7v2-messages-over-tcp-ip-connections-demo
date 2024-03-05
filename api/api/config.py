import os


class _Config:
    GOOGLE_CLOUD_PROJECT = os.environ["GOOGLE_CLOUD_PROJECT"]
    HL7V2_DATASET_NAME = os.environ["HL7V2_DATASET_NAME"]
    HL7V2_DATASET_LOCATION = os.environ["HL7V2_DATASET_LOCATION"]
    HL7V2_STORE_NAME = os.environ["HL7V2_STORE_NAME"]

    @staticmethod
    def init_app(app):
        pass


config = _Config()
