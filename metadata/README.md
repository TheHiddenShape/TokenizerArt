# Metadata Setup Guide

## Structure

Puisque tous vos NFTs partagent la même image, vous avez deux options:

### Option 1: Un seul fichier JSON (recommandé pour collection uniforme)
- Créer `metadata.json` avec l'image IPFS
- Tous les tokens retournent le même metadata

### Option 2: Fichiers JSON individuels (pour personnalisation)
- Créer `0.json`, `1.json`, `2.json`, etc.
- Chaque token peut avoir un nom différent (#0, #1, #2...)
- Mais tous pointent vers la même image

## Processus d'upload sur IPFS

### 1. Upload votre image
```bash
# Via Pinata.cloud (gratuit)
1. Créer un compte sur https://pinata.cloud
2. Upload votre image
3. Récupérer le CID (ex: QmX1eB3...)
4. Votre image sera à: ipfs://QmX1eB3.../image.png
```

### 2. Mettre à jour metadata.json
Remplacer `QmYOUR_IMAGE_HASH_HERE` par votre CID réel.

### 3. Upload le fichier metadata.json sur IPFS
```bash
1. Upload metadata.json sur Pinata
2. Récupérer le nouveau CID (ex: QmY2fC4...)
3. Votre metadata sera à: ipfs://QmY2fC4.../metadata.json
```

### 4. Deploy le contrat
```typescript
// Dans le script de déploiement
const nft = await deploy("RiddlerNFT", ["ipfs://QmY2fC4.../metadata.json"]);
```

## Services IPFS recommandés

- **Pinata** (https://pinata.cloud) - Interface web simple, gratuit jusqu'à 1GB
- **NFT.Storage** (https://nft.storage) - Gratuit, spécialisé NFT
- **Filebase** (https://filebase.com) - S3-compatible, gratuit jusqu'à 5GB

## Alternative: Fichiers individuels

Si vous voulez des noms différents par token:

```
metadata/
  ├── image.png          (votre image unique)
  ├── 0.json            (token #0: "RiddlerNFT #0")
  ├── 1.json            (token #1: "RiddlerNFT #1")
  ├── 2.json            (token #2: "RiddlerNFT #2")
  └── ...
```

Puis upload tout le dossier sur IPFS:
```bash
# Via CLI IPFS
ipfs add -r metadata/
# Retourne: QmFolderHash

# Deploy avec:
const nft = await deploy("RiddlerNFT", ["ipfs://QmFolderHash/"]);
# Token #0 → ipfs://QmFolderHash/0.json
# Token #1 → ipfs://QmFolderHash/1.json
```
