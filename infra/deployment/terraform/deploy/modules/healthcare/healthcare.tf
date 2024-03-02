resource "google_healthcare_dataset" "transmitting_hl7v2_messages_over_tcp_ip_connections" {
  name     = "transmitting-hl7v2-messages-over-tcp-ip-connections-dataset"
  location = "northamerica-northeast1"
}

resource "google_healthcare_hl7_v2_store" "transmitting_hl7v2_messages_over_tcp_ip_connections" {
  name                     = "transmitting-hl7v2-messages-over-tcp-ip-connections-hl7-v2-store"
  dataset                  = google_healthcare_dataset.transmitting_hl7v2_messages_over_tcp_ip_connections.id
  reject_duplicate_message = true

  notification_configs {
    pubsub_topic = google_pubsub_topic.transmitting_hl7v2_messages_over_tcp_ip_connections_store_notifications.id
  }
}

