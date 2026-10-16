---
title: Data protection
nav: Data protection
modified_at: 2026-10-16 00:00:00
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

For managed database backups, see the [security overview][backups-overview] and the current
[database backup policy][backup-policies].

### Data Isolation

Application owners remain responsible for authentication and authorization in their applications. See
[application security][application-security] for container isolation and image immutability.

### Data Privacy

The [Data Processing Agreement][dpa-en] describes Scalingo's processing of personal data and applicable subprocessors.
External services selected for an application have their own terms and controls.

### Data Integrity

Build and runtime containers are separate. The [Buildpack Security page][buildpack-security] describes their lifecycle.

### Resilience

Availability commitments depend on the product and service class. See the applicable [Service Level Agreement][sla-en].

[database-features]: {% post_url databases/about/2000-01-01-features %}
[backup-policies]: {% post_url databases/about/2000-01-01-backup-policies %}
[backups-overview]: {% post_url security/overview/2000-01-01-backups %}
[application-security]: {% post_url security/overview/2000-01-01-application-security %}
[buildpack-security]: {% post_url security/overview/2000-01-01-buildpack-security %}
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

Consultez la page [Sauvegardes][backups-overview] et la
[politique de sauvegarde des bases de données (en anglais)][backup-policies] pour les détails.

### Isolation des données {#isolation-des-donnees}

Le propriétaire de l'application reste responsable de l'authentification et des autorisations dans l'application.
Consultez la page [Sécurité des applications][application-security] pour l'isolation des conteneurs et l'immutabilité
des images.

### Confidentialité des données {#confidentialite-des-donnees}

L'[Accord de traitement des données][dpa-fr] décrit le traitement des données personnelles par Scalingo et les sous-traitants
ultérieurs concernés. Les services externes associés à une application ont leurs propres conditions et contrôles.

### Intégrité des données {#integrite-des-donnees}

Les conteneurs de build et d'exécution sont séparés. La page [Sécurité des buildpacks][buildpack-security] décrit leur
cycle de vie.

### Résilience {#resilience}

Les engagements de disponibilité dépendent du produit et de la classe de service. Consultez les
[engagements de service applicables][sla-fr].

[dpa-fr]: https://scalingo.com/fr/contrat-gestion-traitements-donnees-personnelles
[sla-fr]: https://scalingo.com/fr/engagements-de-services
