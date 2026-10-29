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

Managed databases created after January 6, 2019 have encryption at rest enabled. For an older database, contact Support
to request activation. For encrypted databases, Scalingo manages the encryption keys and rotates them regularly. TLS is
available for Scalingo databases. The Force TLS setting rejects non-TLS connections; its default depends on the database
product and architecture model. See [database network exposure][database-network-exposure] and
[managed database features][database-features], then enable Force TLS where needed.

### Data Backups

For managed database backups, see the [security overview][backups-overview] and the current
[database backup policy][backup-policies].

### Data Isolation

Configure authentication and authorization in your application to control access to its data. See
[application security][application-security] for container isolation and image immutability.

### Data Privacy

The [Data Processing Agreement][dpa-en] describes Scalingo's processing of personal data and applicable subprocessors.
External services selected for an application have their own terms and controls.

### Data Integrity

Application builds run in containers isolated from runtime containers. See [Buildpack Security][buildpack-security] for
the build lifecycle and [Application Security][application-security] for image immutability.

### Resilience

Availability commitments depend on the product and service class. See the applicable [Service Level Agreement][sla-en].
For platform continuity and disaster recovery, see [Business Continuity and Disaster Recovery][business-continuity].

[database-features]: {% post_url databases/about/2000-01-01-features %}
[database-network-exposure]: {% post_url databases/about/2000-01-01-network-exposure %}
[backup-policies]: {% post_url databases/about/2000-01-01-backup-policies %}
[backups-overview]: {% post_url security/overview/2000-01-01-backups %}
[application-security]: {% post_url security/overview/2000-01-01-application-security %}
[business-continuity]: {% post_url security/overview/2000-01-01-business-disaster %}
[buildpack-security]: {% post_url security/overview/2000-01-01-buildpack-security %}
[dpa-en]: https://scalingo.com/data-processing-agreement
[sla-en]: https://scalingo.com/service-level-agreement

---

## Français {#fr}

### Mesures de protection du code et des données {#mesures-de-protection}

### Chiffrement des données {#chiffrement-des-donnees}

Les bases de données managées créées après le 6 janvier 2019 sont chiffrées au repos. Pour une base plus ancienne,
contactez le support pour demander l'activation du chiffrement. Pour les bases chiffrées, Scalingo gère les clés de
chiffrement et les renouvelle régulièrement. TLS est disponible pour les bases de données Scalingo. Le paramètre Force TLS
rejette les connexions sans TLS ; son état par défaut dépend du produit et du modèle d'architecture. Consultez la page sur
l'[exposition réseau des bases de données (en anglais)][database-network-exposure] et les
[fonctionnalités des bases de données managées (en anglais)][database-features], puis activez Force TLS si nécessaire.

### Sauvegardes de données {#sauvegardes-de-donnees}

Consultez la page [Sauvegardes][backups-overview] et la
[politique de sauvegarde des bases de données (en anglais)][backup-policies] pour les détails.

### Isolation des données {#isolation-des-donnees}

Configurez l'authentification et les autorisations dans votre application pour contrôler l'accès aux données. Consultez
la page [Sécurité des applications][application-security] pour l'isolation des conteneurs et l'immutabilité des images.

### Confidentialité des données {#confidentialite-des-donnees}

L'[Accord de traitement des données][dpa-fr] décrit le traitement des données personnelles par Scalingo et les sous-traitants
ultérieurs concernés. Les services externes associés à une application ont leurs propres conditions et contrôles.

### Intégrité des données {#integrite-des-donnees}

Les builds applicatifs s'exécutent dans des conteneurs isolés des conteneurs d'exécution. Consultez la page
[Sécurité des buildpacks][buildpack-security] pour le cycle de build et la page
[Sécurité des applications][application-security] pour l'immutabilité des images.

### Résilience {#resilience}

Les engagements de disponibilité dépendent du produit et de la classe de service. Consultez les
[engagements de service applicables][sla-fr]. Pour la continuité d'activité et la reprise après sinistre de la plateforme,
consultez la page [Continuité d'activité et reprise après sinistre][business-continuity].

[dpa-fr]: https://scalingo.com/fr/contrat-gestion-traitements-donnees-personnelles
[business-continuity]: {% post_url security/overview/2000-01-01-business-disaster %}
[sla-fr]: https://scalingo.com/fr/engagements-de-services
