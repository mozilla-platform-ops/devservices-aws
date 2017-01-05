resource "aws_route53_record" "servo_vcs_sync_mozops_net" {
    zone_id = "${data.terraform_remote_state.base.mozops_route53_zone_id}"
    name = "servo-vcs-sync.mozops.net"
    type = "A"
    ttl = "30"
    # We use the private IP here because access is only allowed through a
    # jumphost.
    records = ["${aws_instance.servo_vcs_sync.private_ip}"]
}
