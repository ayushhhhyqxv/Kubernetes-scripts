ExternalDNS  ExternalName  Headless  Ingress  README.md

cd ExternalName 

ls

# Create namespaces for isolation
kubectl create ns database-ns  # Namespace for database resources
kubectl create ns application-ns  # Namespace for application resources

# View and apply database deployment and service configurations
cat db.yaml && cat db_svc.yaml
# db.yaml contains a Deployment for PostgreSQL database in database-ns
# db_svc.yaml creates a ClusterIP Service to expose the database internally

# Apply database resources
kubectl apply -f db.yaml
kubectl apply -f db_svc.yaml
# Output: deployment.apps/my-database created
#         service/my-database-service created

# View ExternalName service configuration
cat externam-db_svc.yaml 
# This creates an ExternalName Service in application-ns that points to 
# the database service in database-ns (my-database-service.database-ns.svc.cluster.local)
# This allows apps in application-ns to access the database using a simple DNS name

# Build and push application Docker image
docker build --no-cache --platform=linux/amd64 -t ttl.sh/saiyamdemo:1h . 
docker push ttl.sh/saiyamdemo:1h
# This builds a container image for the application with platform specification
# and pushes it to a temporary registry (ttl.sh)

# Deploy the application pod
kubectl apply -f apppod.yaml
# apppod.yaml presumably contains a Pod spec that uses the built image
# and connects to the database via the ExternalName service

# Check application logs to verify database connection
kubectl logs my-application -n application-ns
# First log shows connection attempt with details:
# host=external-db-service (using ExternalName)
# port=5432 (PostgreSQL default)
# Using default postgres credentials

# Second log check shows just "Connecting to database" 
# suggesting either connection is hanging or logs are truncated