---
title: Data protection
nav: Data protection
modified_at: 2026-04-16 00:00:00
tags: compliance security measures
index: 5
---

- [English version](#en)
- [Version française](#fr)

<a id="en"></a>

## English

### Measures protecting your code and data

### Data Encryption

All data stored on the platform is encrypted at rest to protect it from unauthorized access. The encryption keys are
managed by the platform and are rotated regularly to ensure that the data is protected from unauthorized access.

### Data Backups

We perform regular backups of the data hosted on the platform to protect it from data loss. The backups are stored in a
secure redundant storage system to ensure that the data is protected from hardware failures and other disasters.

**Note**: The backup of the databases varies depending on the database plan and technology. Please refer to the database
documentation for more information.

### Data Isolation

Each application hosted on the platform is isolated from other applications to prevent unauthorized access to the data.
The platform uses containerization to isolate each application in its own container and to prevent unauthorized access
between containers.

### Data Privacy

We take data privacy seriously and we are committed to protecting the privacy of our users' data. We do not share our
users' data with third parties without their consent and we take all necessary measures to protect the data from
unauthorized access.

### Data Integrity

Your applications are built on separate containers (builders), which are isolated from the runtime containers. This
ensures that the code you deploy is not tampered with during the build process. Furthermore, the images built are
immutable and cannot be modified once they are produced and deployed.

### Resilience

The platform is designed to be resilient to hardware failures and other disasters. We use redundant storage systems to
protect the data from hardware failures and we have multiple datacenters to protect the platform from disasters such as
fires and floods.

---

<a id="fr"></a>

## Français

### Mesures de Protection de votre Code et de vos Données

### Chiffrement des Données

Toutes les données stockées sur la plateforme sont chiffrées au repos pour les protéger contre les accès non autorisés. Les clés de chiffrement sont gérées par la plateforme et sont renouvelées régulièrement pour garantir que les données sont protégées contre les accès non autorisés.

### Sauvegardes de Données

Nous effectuons des sauvegardes régulières des données hébergées sur la plateforme pour les protéger contre la perte de données. Les sauvegardes sont stockées dans un système de stockage redondant sécurisé pour garantir que les données sont protégées contre les pannes matérielles et autres catastrophes.

**Note** : La sauvegarde des bases de données varie en fonction du plan et de la technologie de la base de données. Veuillez vous référer à la documentation de la base de données pour plus d'informations.

### Isolation des Données

Chaque application hébergée sur la plateforme est isolée des autres applications pour empêcher l'accès non autorisé aux données. La plateforme utilise la conteneurisation pour isoler chaque application dans son propre conteneur et pour empêcher les accès non autorisés entre conteneurs.

### Confidentialité des Données

Nous prenons la confidentialité des données au sérieux et nous nous engageons à protéger la confidentialité des données de nos utilisateurs. Nous ne partageons pas les données de nos utilisateurs avec des tiers sans leur consentement et nous prenons toutes les mesures nécessaires pour protéger les données contre les accès non autorisés.

### Intégrité des Données

Vos applications sont construites sur des conteneurs séparés (builders), qui sont isolés des conteneurs d'exécution. Cela garantit que le code que vous déployez n'est pas altéré pendant le processus de construction. De plus, les images construites sont immuables et ne peuvent pas être modifiées une fois qu'elles sont produites et déployées.

### Résilience

La plateforme est conçue pour être résiliente aux pannes matérielles et autres catastrophes. Nous utilisons des systèmes de stockage redondants pour protéger les données contre les pannes matérielles et nous avons plusieurs datacenters pour protéger la plateforme contre les catastrophes telles que les incendies et les inondations.
