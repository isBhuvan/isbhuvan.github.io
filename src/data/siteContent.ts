export interface CardTheme {
  gradient: string;
  patternShape: string;
  pw: number;
  ph: number;
}

export const cardThemes: CardTheme[] = [
  {
    gradient: "linear-gradient(135deg, #1d4ed8 0%, #7dd3fc 100%)",
    patternShape: `<circle cx="10" cy="10" r="1.5" fill="currentColor"/>`,
    pw: 20, ph: 20,
  },
  {
    gradient: "linear-gradient(135deg, #6d28d9 0%, #c4b5fd 100%)",
    patternShape: `<line x1="0" y1="0" x2="20" y2="20" stroke="currentColor" stroke-width="1.5"/><line x1="20" y1="0" x2="0" y2="20" stroke="currentColor" stroke-width="1.5"/>`,
    pw: 20, ph: 20,
  },
  {
    gradient: "linear-gradient(135deg, #0e7490 0%, #67e8f9 100%)",
    patternShape: `<path d="M 20 0 L 0 0 0 20" fill="none" stroke="currentColor" stroke-width="1"/>`,
    pw: 20, ph: 20,
  },
  {
    gradient: "linear-gradient(135deg, #065f46 0%, #6ee7b7 100%)",
    patternShape: `<path d="M 10 2 v16 M 2 10 h16" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>`,
    pw: 20, ph: 20,
  },
  {
    gradient: "linear-gradient(135deg, #c2410c 0%, #fdba74 100%)",
    patternShape: `<path d="M 10 0 L 18 5 L 18 15 L 10 20 L 2 15 L 2 5 Z" fill="none" stroke="currentColor" stroke-width="1"/>`,
    pw: 20, ph: 20,
  },
  {
    gradient: "linear-gradient(135deg, #9f1239 0%, #fda4af 100%)",
    patternShape: `<path d="M 10 2 L 18 10 L 10 18 L 2 10 Z" fill="none" stroke="currentColor" stroke-width="1"/>`,
    pw: 20, ph: 20,
  },
];

export interface Project {
  href: string;
  tags: string[];
  meta: string;
  title: string;
  desc: string;
  featured?: boolean;
  iconPath: string;
}

export const projects: Project[] = [
  {
    href: "https://github.com/isbhuvan/terraform-azurerm-resource-group",
    tags: ["Terraform", "Azure"],
    meta: "Module — 2026",
    title: "Terraform AzureRM Resource Group Module",
    desc: "Reusable module for provisioning and standardizing Azure Resource Groups with consistent naming and tags.",
    featured: true,
    iconPath: "M3 7h18v12H3z M8 7V5h8v2",
  },
  {
    href: "https://github.com/isbhuvan/terraform-azurerm-management-group",
    tags: ["Terraform", "Azure", "Governance"],
    meta: "Module — 2026",
    title: "Terraform AzureRM Management Group Module",
    desc: "Module for creating and organizing Azure Management Groups for hierarchy, policy, and subscription governance.",
    iconPath: "M16 18L22 12L16 6 M8 6L2 12L8 18",
  },
  {
    href: "https://github.com/isbhuvan/terraform-azurerm-network-security-group",
    tags: ["Terraform", "Azure", "Security", "Networking"],
    meta: "Module — 2026",
    title: "Terraform AzureRM Network Security Group Module",
    desc: "Module for defining Azure NSGs and rule sets to enforce network traffic controls across environments.",
    iconPath: "M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z",
  },
  {
    href: "https://github.com/isbhuvan/terraform-azurerm-private-dns-zone",
    tags: ["Terraform", "Azure", "DNS", "Networking"],
    meta: "Module — 2026",
    title: "Terraform AzureRM Private DNS Zone Module",
    desc: "Module for deploying and managing Azure Private DNS Zones and virtual network links for private name resolution.",
    iconPath: "M3 11h18 M8 7l-5 4 5 4 M16 7l5 4-5 4",
  },
  {
    href: "https://github.com/isbhuvan/terraform-azurerm-application-security-group",
    tags: ["Terraform", "Azure", "Security", "Networking"],
    meta: "Module — 2026",
    title: "Terraform AzureRM Application Security Group Module",
    desc: "Module for creating Application Security Groups to simplify workload-based NSG rule targeting in Azure.",
    iconPath: "M12 2v20 M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6",
  },
  {
    href: "https://github.com/isbhuvan/terraform-azurerm-subnet",
    tags: ["Terraform", "Azure", "Networking"],
    meta: "Module — 2026",
    title: "Terraform AzureRM Subnet Module",
    desc: "Module to provision Azure subnets with optional service endpoints, delegations, and security attachments.",
    iconPath: "M12 2l10 5.5v11L12 22 2 17.5v-11L12 2z",
  },
  {
    href: "https://github.com/isbhuvan/terraform-azurerm-virtual-network",
    tags: ["Terraform", "Azure", "Networking"],
    meta: "Module — 2026",
    title: "Terraform AzureRM Virtual Network Module",
    desc: "Module for creating Azure virtual networks with reusable address space and environment-friendly configuration.",
    iconPath: "M4 12h16 M12 4v16 M6 6l12 12 M18 6 6 18",
  },
];

export const projectFilterTags = [
  "Terraform",
  "Azure",
  "Networking",
  "Security",
  "Governance",
  "DNS",
  "Core",
];

export interface SkillTool {
  icon: string;
  name: string;
}

export const skillTools: SkillTool[] = [
  { icon: "devicon-azure-plain colored", name: "Azure" },
  { icon: "devicon-kubernetes-plain colored", name: "Kubernetes" },
  { icon: "devicon-terraform-plain colored", name: "Terraform" },
  { icon: "devicon-docker-plain colored", name: "Docker" },
  { icon: "devicon-git-plain colored", name: "Git" },
  { icon: "devicon-argocd-plain colored", name: "GitOps" },
  { icon: "devicon-bash-plain", name: "Shell Script" },
  { icon: "devicon-github-original", name: "GitHub Actions" },
  { icon: "devicon-go-original-wordmark colored", name: "Golang" },
  { icon: "devicon-prometheus-original colored", name: "Prometheus" },
  { icon: "devicon-linux-plain", name: "Linux" },
  { icon: "devicon-vscode-plain colored", name: "VS Code" },
];

export interface BlogPlaceholder {
  href: string;
  tags: string[];
  primaryTag?: string | null;
  date: string;
  title: string;
  excerpt: string;
  featured?: boolean;
  cover?: string | null;
}

export const blogPlaceholders: BlogPlaceholder[] = [
  {
    href: "/blog/aks-platform-terraform",
    tags: ["Azure", "Kubernetes", "Terraform"],
    date: "January 2025",
    title: "Building a Production-Grade AKS Platform with Terraform",
    excerpt:
      "A deep dive into provisioning multi-region AKS clusters with Terraform — covering node pool design, AAD integration, private endpoints, and GitOps-ready cluster bootstrap from day zero.",
    featured: true,
  },
  {
    href: "/blog/terraform-state-scale",
    tags: ["Terraform", "GitHub Actions"],
    date: "November 2024",
    title: "Terraform State Management at Scale",
    excerpt:
      "How to structure remote state in Azure Storage with per-environment backends, workspace strategies, and state locking — plus how to safely migrate between backends without destroying resources.",
  },
  {
    href: "/blog/gitops-argocd",
    tags: ["Kubernetes", "GitHub Actions"],
    date: "September 2024",
    title: "GitOps on AKS with ArgoCD and GitHub Actions",
    excerpt:
      "A practical walkthrough of wiring ArgoCD to a GitHub monorepo using GitHub Actions — with automated image promotion, Helm value overrides per environment, and rollback strategies that actually work.",
  },
  {
    href: "/blog/kubernetes-operators-go",
    tags: ["Golang", "Kubernetes"],
    date: "July 2024",
    title: "Writing Kubernetes Operators in Go — A Practical Primer",
    excerpt:
      "Why controller-runtime beats raw client-go for most operators, how to structure reconcile loops, and hard-won lessons about finalizers, requeue delays, and status conditions after shipping two production operators.",
  },
  {
    href: "/blog/azure-real-cost",
    tags: ["Azure", "Terraform"],
    date: "May 2024",
    title: "The Real Cost of Azure: What the Portal Won't Show You",
    excerpt:
      "Egress between regions, underutilised reserved instances, oversized node pools — a frank breakdown of where Azure bills quietly balloon, and how to bake cost guardrails into your Terraform from day one.",
  },
];

export const blogFilterTags = [
  "Azure",
  "Kubernetes",
  "Terraform",
  "GitHub Actions",
  "Golang",
];
