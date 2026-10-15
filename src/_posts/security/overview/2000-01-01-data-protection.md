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

### Measures protecting your code and data

### Data Encryption

Managed databases provisioned on Scalingo have encryption at rest enabled. TLS availability and defaults depend on the
database engine and instance. Check the product documentation and enforce TLS where supported; see
[managed database features][database-features].

### Data Backups

Backup methods and retention vary by managed database engine, architecture, and service class. See the current
[database backup policy][backup-policies]. Backups for services outside Scalingo's managed database scope must be
arranged with their provider.

### Data Isolation

Each application runs in its own container, isolated from other application containers. This is one layer of platform
isolation; application authentication and authorization remain the application owner's responsibility. See
[application security][application-security].

### Data Privacy

The [Data Processing Agreement][dpa-en] describes Scalingo's processing of personal data and applicable subprocessors.
External services selected for an application have their own terms and controls. Connecting one to a Scalingo
application does not automatically include it in Scalingo's HDS scope; check the provider's certification and contract.

### Data Integrity

Build and runtime containers are separate, and the deployed container image is immutable.

### Resilience

Availability commitments and recovery options depend on the product and service class. See the applicable
[Service Level Agreement][sla-en] and product-specific backup documentation.

[database-features]: {% post_url databases/about/2000-01-01-features %}
[backup-policies]: {% post_url databases/about/2000-01-01-backup-policies %}
[application-security]: {% post_url security/overview/2000-01-01-application-security %}
[dpa-en]: https://scalingo.com/data-processing-agreement
[sla-en]: https://scalingo.com/service-level-agreement

---

## Français {#fr}

### Mesures de protection du code et des données {#mesures-de-protection}

### Chiffrement des données {#chiffrement-des-donnees}

Les bases de données managées créées sur Scalingo sont chiffrées au repos. La disponibilité et les paramètres TLS
dépendent du moteur et de l'instance. Consultez la documentation du produit et imposez TLS lorsqu'il est pris en charge ;
voir les [fonctionnalités des bases de données managées (en anglais)][database-features].

### Sauvegardes de données {#sauvegardes-de-donnees}

Les méthodes et la durée de conservation des sauvegardes varient selon le moteur, l'architecture et la classe de service
de la base de données managée. Consultez la [politique de sauvegarde des bases de données (en anglais)][backup-policies]. Les
sauvegardes des services hors du périmètre des bases de données managées par Scalingo doivent être organisées avec leur
fournisseur.

### Isolation des données {#isolation-des-donnees}

Chaque application s'exécute dans son propre conteneur, isolé des autres conteneurs applicatifs. Cette isolation ajoute
une couche de protection au niveau de la plateforme. Le propriétaire de l'application reste responsable de
l'authentification et des autorisations dans l'application. Consultez la page
[Sécurité des applications][application-security].

### Confidentialité des données {#confidentialite-des-donnees}

L'[Accord de traitement des données][dpa-fr] décrit le traitement des données personnelles par Scalingo et les sous-traitants
ultérieurs concernés. Les services externes associés à une application ont leurs propres conditions et contrôles. Leur
utilisation n'étend pas automatiquement le périmètre HDS de Scalingo à ces services. Vérifiez la certification du
fournisseur et le contrat applicable.

### Intégrité des données {#integrite-des-donnees}

Les conteneurs de build et d'exécution sont séparés. Une fois déployée, l'image conteneur ne peut pas être modifiée.

### Résilience {#resilience}

Les engagements de disponibilité et les options de restauration dépendent du produit et de la classe de service. Consultez
les [engagements de service applicables][sla-fr] et la documentation de sauvegarde du produit.

[dpa-fr]: https://scalingo.com/fr/contrat-gestion-traitements-donnees-personnelles
[sla-fr]: https://scalingo.com/fr/engagements-de-services
