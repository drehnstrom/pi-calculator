echo "Enabling Services"
gcloud services enable compute.googleapis.com container.googleapis.com

echo "Creating Instance Template..."
gcloud compute instance-templates create-with-container pi-tamplate --machine-type=e2-medium --tags=http-server --image=cos-stable-85-13310-1209-24 --image-project=cos-cloud --container-image=drehnstrom/pi-calc:v1.0

echo "Creating Health Check..."
gcloud compute health-checks create http "pi-health-check" --timeout=10 --check-interval=30 --unhealthy-threshold=3 --healthy-threshold=1 --port=80 --request-path "/"

echo "Creating Instance Group..."
gcloud beta compute instance-groups managed create pi-group --base-instance-name=pi-group --template=pi-tamplate --size=1 --zone=us-central1-a --health-check=pi-health-check --initial-delay=300

echo "Setting Autoscaling Rules..."
gcloud beta compute instance-groups managed set-autoscaling "pi-group" --zone=us-central1-a --cool-down-period=60 --max-num-replicas=5 --min-num-replicas=1 --target-cpu-utilization "0.75" --mode "on"

echo "Creating Backend Service..."
gcloud compute backend-services create web-backend-service --protocol=HTTP --port-name=http  --health-checks=pi-health-check --global
gcloud compute backend-services add-backend web-backend-service --instance-group=pi-group --instance-group-zone=us-central1-a --global

echo "Creating Load Balancer..."
gcloud compute url-maps create web-map-http --default-service=web-backend-service
gcloud compute target-http-proxies create http-proxy --url-map=web-map-http
gcloud compute forwarding-rules create http-content-rule  --global --target-http-proxy=http-proxy --ports=80

echo "Done"