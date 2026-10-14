---
title: Security Monitoring, Journaling and Logging
nav: Monitoring
modified_at: 2026-10-14 00:00:00
tags: compliance security measures monitoring
index: 4
---

- [English version](#en)
- [Version française](#fr)

## English {#en}

### Application and database logs

Application logs are the output your application writes to `stdout` and `stderr`. Database add-on logs contain output
from the managed database service. Router logs, which record requests to an application, can be enabled separately.
Recent logs are available in the dashboard and CLI; older logs are available as downloadable archives. The current
[logs guide][logs] documents a one-year retention period, archive behavior, and ingestion limits. You can forward logs
to another service with a [log drain][log-drain].

Applications control the content of their application logs. Do not write credentials or unnecessary personal or health
data to logs. If logs may contain personal, health, or other sensitive customer data, use encrypted transport such as
TLS and check the receiving provider's processing terms and HDS scope, as well as its retention and access policies.

### Metrics and alerts

Use the dashboard metrics for application resources and the database-specific metrics for managed database health. The
available measurements depend on the resource and service class. See the [application metrics][app-metrics] and your
database's monitoring documentation. Database backup success and recovery events can also be sent to application
notifiers; see the [backup policy][backup-policies].

For suspected security issues, see [incident and support information][incident-support] and report them to
[security@scalingo.com](mailto:security@scalingo.com).

---

## Français {#fr}

### Journaux applicatifs et de bases de données

Les journaux applicatifs correspondent aux sorties que votre application écrit sur `stdout` et `stderr`. Les journaux
d'add-on de base de données contiennent les sorties du service de base de données managé. Les journaux du routeur, qui
enregistrent les requêtes vers une application, peuvent être activés séparément. Les journaux récents sont accessibles
dans le tableau de bord et la CLI ; les journaux plus anciens sont disponibles sous forme d'archives téléchargeables.
Le [guide des journaux (en anglais)][logs] en vigueur décrit une durée de conservation d'un an, le fonctionnement des archives et
les limites d'ingestion. Vous pouvez transférer vos journaux vers un autre service au moyen d'un [drain de logs (en anglais)][log-drain].

Les applications contrôlent le contenu de leurs journaux applicatifs. N'y écrivez pas d'identifiants ni de données
personnelles ou de santé qui ne sont pas nécessaires. Si les journaux peuvent contenir des données personnelles, de santé
ou d'autres données client sensibles, utilisez un transport chiffré comme TLS et vérifiez les conditions de traitement
et le périmètre HDS du fournisseur destinataire, ainsi que ses règles de conservation et d'accès.

### Métriques et alertes

Utilisez les métriques du tableau de bord pour les ressources applicatives et les métriques propres à la base de données
pour suivre la santé des bases managées. Les mesures disponibles dépendent de la ressource et de sa classe de service.
Consultez la [documentation des métriques applicatives (en anglais)][app-metrics] et celle de la supervision du moteur de base de
données utilisé. Les événements de sauvegarde et de restauration des bases de données peuvent également être transmis
aux notificateurs de l'application ; consultez la [politique de sauvegarde (en anglais)][backup-policies].

En cas de soupçon d'incident de sécurité, consultez les [informations sur les incidents et le support][incident-support]
et écrivez à [security@scalingo.com](mailto:security@scalingo.com).

[logs]: {% post_url platform/app/2000-01-01-logs %}
[log-drain]: {% post_url platform/app/2000-01-01-log-drain %}
[app-metrics]: {% post_url platform/app/2000-01-01-metrics %}
[backup-policies]: {% post_url databases/about/2000-01-01-backup-policies %}
[incident-support]: {% post_url security/overview/2000-01-01-incident-support %}
