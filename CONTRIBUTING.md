# Contributing Guidelines

First off, thank you for taking the time to explore my code! While this is a personal portfolio, I maintain it using professional software engineering standards.

This document outlines the workflow and tools used to keep this project clean, secure, and maintainable.

---

## 🛠️ Development Setup

This project uses a Makefile to simplify common development tasks. To get started, ensure you have the following installed:

- Git
- Node.js and npm (required for linting and Lighthouse checks)

### Quick Start

1. Clone the repo: git clone <https://github.com/isbhuvan/isbhuvan.github.io.git>
2. Start a local server: make serve
3. Run all checks: make check

---

## 🌿 Branching Strategy

I follow a simplified **Git Flow** model. Please do not commit directly to the `main` branch.

-  `main`: The production-ready branch. Anything here is automatically deployed to the live site.
-  `feature/feature-name`: Used for new sections, components, or styling updates.
-  `fix/bug-name`: Used for resolving issues or broken links.

---

## 💬 Commit Message Standards

This project enforces the **Conventional Commits*-  specification. This ensures the project history is readable and can be used to generate automatic changelogs.

**Format:** `<type>: <description>`

-  `feat`: A new feature (e.g., `feat: add project gallery section`)
-  `fix`: A bug fix (e.g., `fix: mobile navigation overlap issue`)
-  `docs`: Documentation only changes (e.g., `docs: update contributing guide`)
-  `style`: Changes that do not affect the meaning of the code (formatting, CSS spacing)
-  `refactor`: A code change that neither fixes a bug nor adds a feature

Commits are validated via commitlint.

---

## ✅ Quality Control Pipeline

Before submitting a Pull Request, please ensure your code passes the local quality checks:

1. **Markdown Linting:** Run `make lint-md` to ensure documentation follows style guides.
2. **Commit Linting:** Run `make lint-commit` to verify your message format.
3. **HTML Linting:** Run `make lint-html` to validate HTML quality.
4. **Lighthouse Check:** Run `make lighthouse` to validate performance, accessibility, best practices, and SEO thresholds.
5. **Full Local Gate:** Run `make check` to execute all checks together.
6. **PR-style Commit Range Check (optional):** Run `make pr-check PR_BASE_SHA=<base_sha> PR_HEAD_SHA=<head_sha>`.
7. **Security Scan:** Ensure no secrets (API keys) are included in your code.

---

## 🚀 Release Process

Releases are automated using semantic versioning:

-  `feat` → Minor version bump
-  `fix` → Patch version bump
-  `BREAKING CHANGE` → Major version bump

CHANGELOG and VERSION are updated automatically.

---

## 🐛 Reporting Issues

Use the provided issue templates for:

-  Bug reports
-  Improvements

---

## 📧 Questions?

If you have any questions or suggestions regarding the architecture of this repo, feel free to open an **Issue** or contact me via [linkedin.com/in/isbhuvan](https://www.linkedin.com/in/isbhuvan).

---
