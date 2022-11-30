resource "google_storage_bucket" "bucket-gcp-atividade" {
  name     = "bucket-gcp-mack-atividade"
  location = "EU"
}

resource "google_compute_network" "rede-gcp" {
  name                    = "rede-gcp"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "sb-gcp" {
  name          = "sb-gcp"
  ip_cidr_range = "10.0.10.0/24"
  region        = "us-east1"
  network       = google_compute_network.rede-gcp.id
}

resource "google_compute_router" "rt-gcp" {
  name    = "router"
  network = google_compute_network.rede-gcp.id
  bgp {
    asn            = 64514
    advertise_mode = "CUSTOM"
  }
}

resource "google_compute_firewall" "fw-gcp" {
  name    = "fw-gcp"
  network = google_compute_network.rede-gcp.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "8080", "4440"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["rundeck"]
}

resource "google_compute_instance" "vm-gcp" {
  name         = "vm-gcp-01"
  machine_type = "e2-medium"
  zone         = "us-east1-c"
  tags         = ["rundeck"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  metadata_startup_script = "sudo apt-get install -yq openjdk-11-jre-headless; curl -L https://packages.rundeck.com/pagerduty/rundeck/gpgkey | sudo apt-key add - ; sudo echo 'deb https://packages.rundeck.com/pagerduty/rundeck/any/ any main' > /etc/apt/sources.list.d/rundeck.list; sudo echo 'deb-src https://packages.rundeck.com/pagerduty/rundeck/any/ any main' >> /etc/apt/sources.list.d/rundeck.list; apt-get update -y; apt-get install -y rundeck; systemctl enable rundeckd.service ;systemctl start rundeckd.service"

  network_interface {
    subnetwork = google_compute_subnetwork.sb-gcp.id

    access_config {
    }
  }
}
