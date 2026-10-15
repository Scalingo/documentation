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

Customer-facing application metrics and alerts are available in the dashboard; managed database metrics depend on the
product and service class. See the [application metrics][app-metrics], [application alerts][alerts], and database-specific
monitoring documentation.

We monitor the platform for production and security incidents. See [incident and support information][incident-support]
for how to report a suspected incident and how we communicate with customers.

### Customer logs

The [logs guide][logs] describes application, database, and router logs, including access and retention. A
[log drain][log-drain] can forward logs to another service.


---

## Français {#fr}

### Supervision et métriques

Les métriques et alertes applicatives accessibles aux clients sont disponibles dans le tableau de bord ; les métriques
des bases de données managées dépendent du produit et de sa classe de service. Consultez la [documentation des métriques
applicatives (en anglais)][app-metrics], le [guide des alertes applicatives (en anglais)][alerts] et la documentation de
supervision du moteur concerné.

Nous surveillons la plateforme afin de détecter les incidents de production et de sécurité. Consultez les [informations
sur les incidents et le support][incident-support] pour savoir comment signaler un incident suspect et comment nous
communiquons avec les clients.

### Journaux client

Le [guide des journaux (en anglais)][logs] décrit les journaux applicatifs, de bases de données et de routeur, notamment
leur accès et leur conservation. Un [drain de logs (en anglais)][log-drain] permet de transférer les journaux vers un autre service.

[app-metrics]: {% post_url platform/app/2000-01-01-metrics %}
[alerts]: {% post_url platform/app/2000-01-01-alerts %}
[logs]: {% post_url platform/app/2000-01-01-logs %}
[log-drain]: {% post_url platform/app/2000-01-01-log-drain %}
[incident-support]: {% post_url security/overview/2000-01-01-incident-support %}
