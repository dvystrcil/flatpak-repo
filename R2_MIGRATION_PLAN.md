# Cloudflare R2 Migration Plan

## Existing Infisical Secrets
- `INFISICAL_CLIENT_ID`
- `INFISICAL_CLIENT_SECRET`

## R2 Credentials in Infisical (FP_*)
- `FP_R2_ACCESS_KEY_ID`
- `FP_R2_SECRET_ACCESS_KEY`
- `FP_R2_BUCKET_NAME`
- `FP_R2_ACCOUNT_ID`

## Updated Workflow Changes

### 1. Fetch secrets from Infisical
Add the Infisical action at the start of the build job:

```yaml
- name: Fetch secrets from Infisical
  uses: Infisical/secrets-action@v1.0.16
  with:
    client-id: ${{ secrets.INFISICAL_CLIENT_ID }}
    client-secret: ${{ secrets.INFISICAL_CLIENT_SECRET }}
    env-slug: prod
    project-slug: homelab-bz-gt
    secret-path: /
    export-type: env
    domain: http://infisical-infisical-standalone-infisical.infisical.svc.cluster.local:8080
```

### 2. Download MekHQ tarball from R2
Replace the download step with:

```yaml
- name: Configure AWS CLI for R2
  run: |
    aws configure set aws_access_key_id $FP_R2_ACCESS_KEY_ID
    aws configure set aws_secret_access_key $FP_R2_SECRET_ACCESS_KEY
    aws configure set region auto

- name: Download MekHQ tarball from R2
  run: |
    VERSION="${{ steps.version.outputs.version }}"
    BUNDLE_NAME="MekHQ-${VERSION}.tar.gz"
    OBJECT_KEY="mekhq/${BUNDLE_NAME}"
    
    # Check if file exists in R2
    if aws --endpoint-url https://${FP_R2_ACCOUNT_ID}.r2.cloudflarestorage.com s3 ls s3://${FP_R2_BUCKET_NAME}/${OBJECT_KEY} 2>/dev/null; then
      echo "Downloading ${OBJECT_KEY} from R2"
      aws --endpoint-url https://${FP_R2_ACCOUNT_ID}.r2.cloudflarestorage.com s3 cp s3://${FP_R2_BUCKET_NAME}/${OBJECT_KEY} mekhq.tar.gz
    else
      echo "File not found in R2, downloading from GitHub releases"
      curl -L -o mekhq.tar.gz "https://github.com/MegaMek/mekhq/releases/download/v${VERSION}/MekHQ-${VERSION}.tar.gz"
    fi
    ls -lh mekhq.tar.gz
```

### 3. Upload MekHQ tarball to R2 (after download from GitHub)
After downloading from GitHub releases, upload to R2 for future builds:

```yaml
- name: Upload MekHQ tarball to R2
  if: github.event.inputs.version != '' || github.event_name == 'push'
  run: |
    VERSION="${{ steps.version.outputs.version }}"
    BUNDLE_NAME="MekHQ-${VERSION}.tar.gz"
    OBJECT_KEY="mekhq/${BUNDLE_NAME}"
    
    aws --endpoint-url https://${FP_R2_ACCOUNT_ID}.r2.cloudflarestorage.com s3 cp mekhq.tar.gz s3://${FP_R2_BUCKET_NAME}/${OBJECT_KEY}
    echo "Uploaded ${OBJECT_KEY} to R2"
```

### 4. Upload flatpak artifacts to R2
Replace the artifact upload with R2 upload:

```yaml
- name: Upload flatpak bundle to R2
  run: |
    VERSION_TAG="${{ steps.version.outputs.version_tag }}"
    BUNDLE_NAME="mekhq-${VERSION_TAG}.flatpak"
    
    aws --endpoint-url https://${FP_R2_ACCOUNT_ID}.r2.cloudflarestorage.com s3 cp ${BUNDLE_NAME} s3://${FP_R2_BUCKET_NAME}/flatpak/${BUNDLE_NAME}
    aws --endpoint-url https://${FP_R2_ACCOUNT_ID}.r2.cloudflarestorage.com s3 cp ${BUNDLE_NAME} s3://${FP_R2_BUCKET_NAME}/flatpak/mekhq-latest.flatpak
    
    echo "Uploaded ${BUNDLE_NAME} to R2"
```

## Implementation Steps

1. [ ] Create R2 bucket (if not already done)
2. [ ] Add R2 credentials to Infisical with FP_ prefix
3. [ ] Update workflow to fetch Infisical secrets
4. [ ] Modify download steps to check R2 first
5. [ ] Add upload steps for MekHQ tarball
6. [ ] Add upload steps for flatpak artifacts
7. [ ] Test workflow

## Environment Variables After Infisical Fetch
After the Infisical step, these will be available:
- `FP_R2_ACCESS_KEY_ID`
- `FP_R2_SECRET_ACCESS_KEY`
- `FP_R2_BUCKET_NAME`
- `FP_R2_ACCOUNT_ID`

## Notes
- Account ID: `2442b7d9e8305ae8c5d25b5faba7a072`
- R2 Endpoint: `https://2442b7d9e8305ae8c5d25b5faba7a072.r2.cloudflarestorage.com`
- Bucket: `flatpak-repo`
