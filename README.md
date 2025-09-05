# Kubernetes Hands-On !!

A comprehensive hands-on project for learning and experimenting with Kubernetes core concepts and advanced features. This repository contains practical examples, deployment configurations, and automation scripts for mastering container orchestration.

![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)


## Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Architecture](#-architecture)


## Overview

This project serves as a complete learning lab for Kubernetes enthusiasts and developers looking to gain practical experience with container orchestration. It includes real-world configurations, deployment patterns, automation scripts, and advanced features that cover essential to enterprise-level Kubernetes concepts.

## Features

- **🏗️ Core Kubernetes Components**: Pods, Deployments, Services, ConfigMaps, Secrets
- **💾 Storage Solutions**: PVs, PVCs, HostPath, EmptyDir, NFS, Local Volumes
- **🌐 Networking**: Services, Ingress, NodePort, ExternalDNS, VETH networking
- **🔐 Security**: RBAC, Authentication, Secrets Management, Admission Policies
- **⚡ Advanced Scheduling**: Node Affinity, Taints/Tolerations, Topology Constraints
- **🔄 Deployment Strategies**: Rolling Updates, Canary, Blue-Green, Probes
- **📊 Resource Management**: QoS, Priority Classes, Resource Quotas
- **🗃️ Stateful Applications**: StatefulSets, Database configurations
- **🤖 GitOps Automation**: ArgoCD, GitHub Actions, Workflow automation
- **🔧 DevOps Tools**: Cert-Manager, Private Registry, Image Webhooks

## Architecture

```mermaid
graph TB
    subgraph "Kubernetes Cluster"
        subgraph "Application Layer"
            A[Web App Pods]
            B[StatefulSet Pods]
            C[Canary Deployment]
        end
        
        subgraph "Configuration Layer"
            D[ConfigMaps]
            E[Secrets]
            F[RBAC]
        end
        
        subgraph "Networking Layer"
            G[Service]
            H[Ingress]
            I[ExternalDNS]
        end
        
        subgraph "Storage Layer"
            J[Persistent Volumes]
            K[Storage Classes]
            L[NFS/Local Storage]
        end
        
        subgraph "Policy Layer"
            M[Resource Quotas]
            N[Priority Classes]
            O[Admission Policies]
        end
    end
    
    subgraph "GitOps Layer"
        P[ArgoCD]
        Q[GitHub Actions]
        R[Workflow Automation]
    end
    
    A --> G
    B --> G
    C --> G
    A --> D
    A --> E
    B --> J
    C --> M
    G --> H
    H --> I
    P --> A
    P --> B
    P --> C
    Q --> P
