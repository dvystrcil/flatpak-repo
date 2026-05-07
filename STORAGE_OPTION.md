# Alternative Storage for MekHQ Flatpak Downloads

## Problem
The MekHQ flatpak build is hitting GitHub's storage limits. Each MekHQ tarball is ~150MB, and with multiple versions, we're consuming significant GitHub Actions storage.

## Current Setup
- GitHub Pages hosts the flatpak repo
- Build workflow downloads MekHQ tarball from GitHub releases each time
- Tarball cached in actions/cache, but still consumes storage

## Option Evaluation

### 1. Self-Hosted File Storage (K8s)
**Pros:**
- Full control, unlimited storage
- Can host from existing homelab K8s
- Faster downloads from local network

**Cons:**
- Requires maintenance
- Need to handle HTTPS/certificates
- External users need internet access to your server

### 2. Alternative CDNs/Storage
**Options:**
- Cloudflare R2 (unlimited storage, free tier)
- Wasabi, Backblaze (cheap object storage)
- AWS S3 + CloudFront

**Pros:**
- Scalable, reliable
- Usually cheaper than GitHub storage

**Cons:**
- Cost (though minimal for this use case)
- Need to manage uploads/credentials

### 3. Reduce Artifact Size
**Options:**
- Compress tarball more aggressively
- Only store latest N versions
- Use git-lfs for large files

**Pros:**
- No infrastructure changes needed

**Cons:**
- Still limited by GitHub's cap
- Won't solve long-term growth

## Recommendation
Use **Cloudflare R2** - it has:
- Unlimited storage
- Free tier with 10GB monthly egress
- S3-compatible API (easy migration)
- Fast global CDN

## Implementation Plan

1. Create Cloudflare R2 bucket
2. Update build workflow to upload/download from R2 instead of GitHub
3. Test with one version
4. Update documentation

## Questions
- Do you want to use homelab K8s or Cloudflare R2?
- Should we keep backward compatibility with existing flatpakrepo?
- How many versions do we want to keep archive?
