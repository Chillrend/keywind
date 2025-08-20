#!/bin/bash

# Remove the existing keywind theme directory from Keycloak
rm -rf ~/keycloak/themes/keywind/

# Copy the new keywind theme to Keycloak's themes directory
cp -r ~/keywind/theme/keywind/ ~/keycloak/themes/keywind

# Restart the Keycloak service
sudo systemctl restart keycloak

# Check the Keycloak service
sudo systemctl restart keycloak
