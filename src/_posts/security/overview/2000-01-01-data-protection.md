---
title: Data protection
nav: Data protection
modified_at: 2026-10-14 00:00:00
tags: compliance security measures
index: 5
---

- [English version](#en)
- [Version française](#fr)

## English {#en}

### Encryption

All managed databases provisioned on Scalingo have encryption at rest enabled. TLS availability and defaults for
connections depend on the database engine and instance. Check the product documentation and enforce TLS where supported;
see [managed database features][database-features]. For public application traffic, configure HTTPS as described in the
[TLS documentation][tls].

### Backups and persistent storage

Backups handled by Scalingo are encrypted. Backup mechanisms, retention, and restore procedures vary by database engine,
architecture, and service class; see the [database backup policy][backup-policies]. The filesystem in an application
container is temporary. Use a managed database or persistent object storage for data that must survive an application
restart or redeployment. Backups for a customer-selected external service must be arranged with that provider.

### Application isolation and build integrity

Each application runs in its own container, isolated from other application containers. This is one layer of platform
isolation; application authentication and authorization remain part of the application owner's responsibility. Build
and runtime containers are separate, and the deployed container image is immutable. See [application security][application-security]
and [file system and file storage][file-storage].

### Processing and third-party services

The [Data Processing Agreement][dpa-en] describes Scalingo's processing of personal data and the applicable
subprocessor arrangements.
An external database, object-storage service, monitoring tool, or other provider selected for an application has its
own terms and controls. Do not assume that connecting it to a Scalingo application makes it part of Scalingo's HDS
certification scope; check the provider's certification and your contractual arrangements. See the current
[HDS certificate and scope][hds-certification].

### Availability and recovery

Availability commitments and recovery options depend on the product and service class. Refer to the applicable
[Service Level Agreement][sla-en] and the product-specific backup documentation for the current terms and procedures.

---

## Français {#fr}

### Chiffrement {#chiffrement-des-donnees}

Toutes les bases de données managées provisionnées sur Scalingo bénéficient du chiffrement au repos. La disponibilité
et les paramètres TLS des connexions dépendent du moteur et de l'instance. Consultez la documentation du produit et
imposez TLS lorsqu'il est pris en charge ; voir les [fonctionnalités des bases de données managées (en anglais)][database-features].
Pour le trafic applicatif public, configurez HTTPS comme décrit dans la [documentation TLS (en anglais)][tls].

### Sauvegardes et stockage persistant {#sauvegardes-de-donnees}

Les sauvegardes réalisées par Scalingo sont chiffrées. Les mécanismes de sauvegarde, la rétention et les procédures de
restauration varient selon le moteur de base de données, l'architecture et la classe de service ; consultez la
[politique de sauvegarde des bases de données (en anglais)][backup-policies]. Le système de fichiers d'un conteneur applicatif est
temporaire. Utilisez une base de données managée ou un stockage objet persistant pour les données qui doivent survivre
au redémarrage ou au redéploiement de l'application. Les sauvegardes d'un service externe choisi par le client doivent
être organisées avec ce fournisseur.

### Isolation des applications et intégrité des images {#isolation-des-donnees}

Chaque application s'exécute dans son propre conteneur, isolé des conteneurs des autres applications. Cette isolation
constitue une couche de protection de la plateforme ; l'authentification et les autorisations au sein de l'application
restent sous la responsabilité de son propriétaire. Les conteneurs de build et d'exécution sont séparés et l'image
conteneur déployée est immuable. Consultez les pages [Sécurité des applications][application-security] et
[Système de fichiers et stockage (en anglais)][file-storage].

### Traitement et services tiers {#confidentialite-des-donnees}

L'[Accord de Traitement des Données][dpa-fr] décrit le traitement des données personnelles par Scalingo et les
accords avec les sous-traitants ultérieurs concernés. Une base de données externe, un service de stockage objet, un outil de supervision ou tout autre fournisseur
choisi pour une application relève de ses propres conditions et contrôles. Ne considérez pas qu'une connexion à une
application Scalingo l'inclut dans le périmètre de certification HDS de Scalingo ; vérifiez la certification du
fournisseur et vos accords contractuels. Consultez le [certificat HDS en vigueur et son périmètre (en anglais)][hds-certification].

### Disponibilité et restauration {#resilience}

Les engagements de disponibilité et les options de restauration dépendent du produit et de la classe de service.
Consultez l'[Accord de Niveau de Service][sla-fr] applicable et la documentation de sauvegarde propre au produit pour
connaître les conditions et procédures en vigueur.

[tls]: {% post_url platform/networking/public/cert/2000-01-01-overview %}
[database-features]: {% post_url databases/about/2000-01-01-features %}
[backup-policies]: {% post_url databases/about/2000-01-01-backup-policies %}
[application-security]: {% post_url security/overview/2000-01-01-application-security %}
[file-storage]: {% post_url platform/app/2000-01-01-filesystem %}
[dpa-en]: https://scalingo.com/data-processing-agreement
[dpa-fr]: https://scalingo.com/fr/contrat-gestion-traitements-donnees-personnelles
[hds-certification]: {% post_url compliance/2000-01-01-hds %}
[sla-en]: https://scalingo.com/service-level-agreement
[sla-fr]: https://scalingo.com/fr/engagements-de-services
