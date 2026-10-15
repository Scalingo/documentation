---
title: Security Monitoring and Logging
nav: Monitoring
modified_at: 2026-10-15 00:00:00
tags: compliance security measures monitoring
index: 4
---

- [English version](#en)
- [Version française](#fr)

## English {#en}

### Monitoring and metrics

The dashboard shows application metrics and alerts. Managed database metrics vary by product and service class. See the
[application metrics][app-metrics], [application alerts][alerts], and database-specific monitoring documentation.

We monitor the platform for production and security incidents. The [incident and support page][incident-support] explains
how to report a suspected incident and how Scalingo communicates with customers.

### Customer logs

The [logs guide][logs] covers application, database, and router logs, including access and retention. Use a
[log drain][log-drain] to forward logs to another service.

---

## Français {#fr}

### Supervision et métriques

Le tableau de bord affiche les métriques et alertes applicatives. Les métriques des bases de données managées varient
selon le produit et sa classe de service. Consultez la [documentation des métriques applicatives (en anglais)][app-metrics],
le [guide des alertes applicatives (en anglais)][alerts] et la documentation de supervision du moteur concerné.

Nous surveillons la plateforme pour détecter les incidents de production et de sécurité. La page [Incidents et support][incident-support]
explique comment signaler un incident suspect et comment Scalingo informe ses clients.

### Journaux client

Le [guide des journaux (en anglais)][logs] décrit les journaux applicatifs, de bases de données et de routeur, ainsi que
leurs modalités d'accès et de conservation. Un [mécanisme de transfert des journaux (log drain, en anglais)][log-drain]
permet de les envoyer vers un autre service.

[app-metrics]: {% post_url platform/app/2000-01-01-metrics %}
[alerts]: {% post_url platform/app/2000-01-01-alerts %}
[logs]: {% post_url platform/app/2000-01-01-logs %}
[log-drain]: {% post_url platform/app/2000-01-01-log-drain %}
[incident-support]: {% post_url security/overview/2000-01-01-incident-support %}
