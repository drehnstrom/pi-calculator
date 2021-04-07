echo "Deleting Load Balancer..."
gcloud compute forwarding-rules delete http-content-rule --global --quiet
gcloud compute target-http-proxies delete http-proxy --quiet
gcloud compute url-maps delete web-map-http --quiet
gcloud compute backend-services delete web-backend-service --global --quiet 

echo "Deleting Instance Groups..."
gcloud beta compute instance-groups managed delete pi-group --zone=us-central1-a --quiet
echo "Deleting Health Check..."
gcloud compute health-checks delete pi-health-check --quiet

echo "Deleting Instance Template..."
gcloud compute instance-templates delete pi-tamplate --quiet

echo "Done"