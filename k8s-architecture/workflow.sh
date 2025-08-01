mkdir -p .github/workflows  # Necessary for Git-ops workflow must be in same code repo 

vi build-push-image.yaml
+----------------------->
name: build and push docker image
on:
  push

jobs:
  release-docker:
    name: Release docker image
    if: "!contains(github.event.head_commit.message, '[skip ci]')"
    runs-on: ubuntu-20.04
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v2

      - name: Log in to Docker Hub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Get git SHA short
        id: vars
        run: echo "sha_short=$(git rev-parse --short HEAD)" >> $GITHUB_ENV
        
      - name: Build and push Docker image
        uses: docker/build-push-action@v4
        with:
          context: app/
          push: true
          tags: |
            saiyam911/kubesimplify-demo:latest
            saiyam911/kubesimplify-demo:sha-${{ env.sha_short }}
          labels: |
            org.opencontainers.image.source=${{ github.repository }}
            org.opencontainers.image.revision=${{ github.sha }}
          
      - name: Generate deploy manifest from Jinja template
        uses: cuchi/jinja2-action@v1.1.0
        with: 
          template: app/tmpl/deploy.j2
          output_file: app/deploy/deploy.yaml
          strict: true
          variables: |
            image_deploy_tag=sha-${{ env.sha_short }}
            
      - name: Configure git for the action
        run: |
          git config --local user.email "action@github.com"
          git config --local user.name "GitHub Action"
          
      - name: Stash unstaged changes
        run: git stash --include-untracked
        
      - name: Pull latest changes from the remote branch
        run: git pull origin main --rebase
        
      - name: Apply stashed changes
        run: git stash pop || echo "No stashed changes to apply"

      - name: Commit deploy manifest on local repo
        run: |
          git add app/deploy/deploy.yaml
          git commit -s -m "[skip ci] Generate deployment manifests"
          
      - name: Push deploy manifests to remote repo
        uses: ad-m/github-push-action@v0.6.0
        with: 
          github_token: ${{ secrets.GITHUB_TOKEN }}
          branch: main

# We have created a jinja file which converts to manifests in following order :

# jinja template +--------> Addition of SHA after image building +----------> manifest of deploy.yaml


# after this GO TO REPO ----> SETTINGS-----> SECRETS & VARIABLES -------> ACTIONS ------> PASS YOUR DOCKER SECRETS !

# Remember to commit after this 

# Installing ArgoCD !

kubectl create namespace argocd

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

kubectl get secret -n argocd argocd-initial-admin-secret -oyaml  # decode the base 64 password for argoCD login !

kubectl crd | grep argo # can use argoCD using crd also,even cli !

kubectl get svc -n argocd 
# Note the IP of load-balancer of argoCD and run on browser ! 

# Use the above password , then give your github repo and monitor it 
