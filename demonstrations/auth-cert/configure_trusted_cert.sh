vault write auth/cert/certs/web \
    display_name=web \
    policies=admin \
    allowed_organizational_units='Acceptance Domain' \
    ttl=3600
