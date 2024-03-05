resource "google_pubsub_topic" "transmitting_hl7v2_messages_over_tcp_ip_connections_store_notifications" {
  name = "transmitting-hl7v2-messages-over-tcp-ip-connections-hl7-v2-store-notifications"
}

resource "google_pubsub_topic_iam_member" "transmitting_hl7v2_messages_over_tcp_ip_connections_store_notifications_healthcare_sa" {
  topic  = google_pubsub_topic.transmitting_hl7v2_messages_over_tcp_ip_connections_store_notifications.name
  role   = "roles/pubsub.publisher"
  member = "serviceAccount:${google_project_service_identity.healthcare_sa.email}"
}