# Portfolio Deployment Guide

This guide describes how to deploy your Flutter portfolio website to GitHub Pages using your custom repository **abhaysharma.github.io**.

## Prerequisites

1. A GitHub account.
2. Git installed on your system.
3. Your local portfolio code (which is configured and ready).

---

## Step 1: Create the GitHub Repository

1. Go to [GitHub](https://github.com) and sign in.
2. Click **New** to create a new repository.
3. Set the **Repository name** to exactly:
   ```text
   abhaysharma.github.io
   ```
4. Set the visibility to **Public** (GitHub Pages requires public repositories for free tier hosting).
5. Do **not** initialize the repository with a README, `.gitignore`, or license (we already have these locally).
6. Click **Create repository**.

---

## Step 2: Initialize Git and Push Code Locally

Run the following commands in your terminal from the project root (`/Users/abhaysharma/Desktop/abhay_portfolio`):

```bash
# 1. Initialize local git repository
git init -b main

# 2. Add all files to staging (uses your existing .gitignore)
git add .

# 3. Create your initial commit
git commit -m "chore: initial commit and setup github actions deployment"

# 4. Link your local repository to your remote GitHub repository
git remote add origin https://github.com/abhaysharma/abhaysharma.github.io.git

# 5. Push your code to the main branch
git push -u origin main
```

---

## Step 3: Configure GitHub Pages Settings

Once you push the code to `main`, the **GitHub Actions workflow** (`.github/workflows/deploy.yml`) will automatically trigger:

1. Go to your repository page on GitHub: `https://github.com/abhaysharma/abhaysharma.github.io`.
2. Click on the **Actions** tab to monitor the build progress.
3. Wait for the build and deployment to complete successfully. This will create a new branch named `gh-pages` in your repository.
4. Go to **Settings** > **Pages** (in the left-hand sidebar).
5. Under **Build and deployment** > **Source**, ensure **Deploy from a branch** is selected.
6. Under **Branch**, select **`gh-pages`** and the folder **`/ (root)`**.
7. Click **Save**.
8. Ensure **Enforce HTTPS** is checked.

Your portfolio site will be live at:
**https://abhaysharma.github.io**

---

## Direct Navigation & Refresh Support

Because Flutter Web uses hash URL strategy (`/#/projects`, `/#/experience`, etc.) by default in this project, direct URL sharing and browser refreshes work automatically on GitHub Pages without requiring any special `404.html` redirect page.
