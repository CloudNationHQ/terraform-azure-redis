data "http" "current_public_ip" {
  url = "https://ipv4.icanhazip.com/"
  request_headers = {
    Accept = "application/json"
  }
}
