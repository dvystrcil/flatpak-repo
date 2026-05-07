# R2 Setup Instructions

## Step 1: Create Cloudflare R2 Bucket

1. Go to https://dash.cloudflare.com/
2. Navigate to **R2** (in the Storage section)
3. Click **Create Bucket**
4. Name it: `flatpak-repo` (or similar)
5. Select region: **Auto** (default)
6. Enable **Bucket Access** (public or private based on your needs)
7. Click **Create Bucket**

## Step 2: Get Your Credentials

1. In the R2 bucket page, click **Overview**
2. Scroll to **Bucket Access**
3. Note your:
   - Account ID (shown at top of dashboard)
   - Access Key ID
   - Secret Access Key

## Step 3: Configure GitHub Secrets

Go to https://github.com/dvystrcil/flatpak-repo/settings/secrets/actions

Create these secrets:
- `R2_ACCESS_KEY_ID` - Your R2 Access Key ID
- `R2_SECRET_ACCESS_KEY` - Your R2 Secret Access Key
- `R2_BUCKET_NAME` - The bucket name (e.g., `flatpak-repo`)
- `R2_ACCOUNT_ID` - Your Cloudflare Account ID

## Step 4: Configure Infisical (optional)

If using Infisical:
1. Install Infisical CLI or GitHub Action
2. Add R2 credentials as secrets in Infisical
3. Configure workflow to load secrets from Infisical

## R2 S3-compatible Endpoint

```
https://<ACCOUNT_ID>.r2.cloudflarestorage.com
```

## Test Connection

```bash
# Install awscli if not available
pip install awscli

# Configure for R2
aws configure set aws_access_key_id YOUR_ACCESS_KEY_ID
aws configure set aws_secret_access_key YOUR_SECRET_ACCESS_KEY
aws configure set region auto

# Test
aws --endpoint-url https://<ACCOUNT_ID>.r2.cloudflarestorage.com s3 ls
```

## Next Steps

After bucket is created and credentials configured:
1. Update build workflow to download from R2
2. Update build workflow to upload artifacts to R2
3. Test the workflow
