---
title: Security Monitoring, Journaling and Logging
nav: Monitoring
modified_at: 2026-10-16 00:00:00
tags: compliance security measures monitoring
index: 4
---

- [English version](#en)
- [Version française](#fr)

## English {#en}

### Scalingo platform monitoring and logs

We monitor the platform for production and security incidents, and our monitoring alerts the operations team. Scalingo
manages its platform logs to operate the service, trace platform changes, and investigate incidents; the operations team
reviews them to identify security incidents. These platform logs are separate from the application and database add-on
logs available to customers.
The [incident and support page][incident-support] explains how to report a suspected incident and how Scalingo
communicates with customers.

### Logs and metrics available to customers

Application logs contain the messages your application writes to `stdout` and `stderr`; you control this content in your
application. You can access application and database add-on logs through the Dashboard and CLI. Router logs are optional;
you can enable them for an application through the CLI. You can also configure a [log drain][log-drain] to forward
application or add-on logs to another provider; adding one does not disable the [Scalingo Logs][logs] feature for those
logs. The [logs guide][logs] covers access and retention, and the [CLI reference][cli-features] documents how to enable
router logs. See [application metrics][app-metrics],
[application alerts][alerts], and the database monitoring guides linked from [database features][database-features].

Avoid writing secrets or unnecessary personal or health data to application logs. If forwarded application or add-on logs
may contain sensitive data, use encrypted transport such as TLS and check the receiving provider's processing, retention,
and access conditions.
For health data subject to HDS requirements, check the provider's HDS scope as well.

---

## Français {#fr}

### Supervision et journaux de la plateforme Scalingo {#supervision-et-journaux-de-la-plateforme-scalingo}

Nous surveillons la plateforme pour détecter les incidents de production et de sécurité. Nos outils alertent l'équipe
d'exploitation. Scalingo gère ses journaux de plateforme pour exploiter le service, suivre les modifications et analyser
les incidents. L'équipe d'exploitation les examine pour repérer les incidents de sécurité. Ces journaux sont distincts
des journaux applicatifs et des add-ons de base de données accessibles aux clients. La page
[Incidents et support][incident-support] explique comment signaler un incident suspect et comment Scalingo informe ses clients.

### Journaux et métriques accessibles aux clients {#journaux-et-metriques-accessibles-aux-clients}

Les journaux applicatifs contiennent les messages que votre application écrit sur `stdout` et `stderr` ; vous en définissez
le contenu dans l'application. Vous pouvez consulter les journaux applicatifs et ceux des add-ons de base de données depuis
le tableau de bord ou la CLI. Les journaux du routeur sont optionnels ; vous pouvez les activer pour une application depuis la CLI. Vous pouvez aussi
configurer un [log drain (mécanisme de transfert des journaux, en anglais)][log-drain] pour transférer les journaux
applicatifs ou ceux des add-ons vers un autre fournisseur ; cela ne désactive pas la fonctionnalité
[Scalingo Logs (en anglais)][logs] pour ces journaux. Le [guide des journaux (en anglais)][logs] décrit leur accès et
leur durée de conservation ; la [référence CLI (en anglais)][cli-features] explique comment activer les journaux du
routeur. Consultez aussi la [documentation des métriques applicatives (en anglais)][app-metrics], le [guide des alertes
applicatives (en anglais)][alerts] et les guides de supervision des bases de données référencés dans les
[fonctionnalités des bases de données (en anglais)][database-features].

Évitez d'écrire dans les journaux applicatifs des secrets ou des données personnelles ou de santé superflues. Si vous
transférez des journaux applicatifs ou d'add-ons susceptibles de contenir des données sensibles, utilisez un transport
chiffré comme TLS et vérifiez les conditions de traitement, de conservation et d'accès du fournisseur destinataire. Pour
les données de santé soumises aux exigences HDS, vérifiez aussi le périmètre HDS du fournisseur.

[app-metrics]: {% post_url platform/app/2000-01-01-metrics %}
[alerts]: {% post_url platform/app/2000-01-01-alerts %}
[database-features]: {% post_url databases/about/2000-01-01-features %}
[logs]: {% post_url platform/app/2000-01-01-logs %}
[log-drain]: {% post_url platform/app/2000-01-01-log-drain %}
[cli-features]: {% post_url tools/cli/2000-01-01-features %}
[incident-support]: {% post_url security/overview/2000-01-01-incident-support %}
