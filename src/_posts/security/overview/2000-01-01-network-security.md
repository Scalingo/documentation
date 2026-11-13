---
title: Network Security
nav: Network
modified_at: 2026-10-16 00:00:00
tags: compliance security measures
index: 2
---

- [English version](#en)
- [Version française](#fr)

## English {#en}

### Public application traffic

The Application Firewall is in Preview and available on request. See the [Application Firewall][application-firewall]
documentation for its scope. It filters by source IPv4 address and does not inspect request content or replace
application-specific protections.

Traffic to public applications passes through Scalingo's routing layer, which filters undesirable traffic and applies
ingress constraints; see the [public routing][routing] documentation. You can add capacity by scaling your application
manually or by configuring and enabling the Autoscaler, but neither method distinguishes malicious traffic from a
legitimate increase. Configure
application-specific protections in your application or through a suitable proxy or CDN.

For private application connectivity, see [Private Networks][private-networks] and [customer VPN
connectivity][connectivity]. Controls for staff access to platform administration are described in
[operational security][operational-security].

---

## Français {#fr}

### Trafic public vers les applications

Le pare-feu applicatif est en préversion et accessible sur demande. Consultez la page
[Pare-feu applicatif (en anglais)][application-firewall] pour connaître son périmètre. Il filtre selon l'adresse IPv4
source, sans inspecter le contenu des requêtes ni remplacer les protections propres à l'application.

Le trafic vers les applications publiques passe par la couche de routage de Scalingo, qui filtre le trafic indésirable et
applique des contraintes au trafic entrant ; consultez la documentation sur le [routage public (en anglais)][routing].
Vous pouvez augmenter la capacité en mettant votre application à l'échelle manuellement ou en configurant et activant
l'autoscaler, mais aucun de ces moyens ne distingue le trafic malveillant d'une hausse légitime. Configurez les protections
propres à votre application ou utilisez un proxy ou un CDN adapté.

Pour la connectivité privée des applications, consultez les pages [Réseaux privés (en anglais)][private-networks] et
[connectivité VPN client (en anglais)][connectivity]. Les contrôles d'accès du personnel à l'administration de la
plateforme sont décrits dans la page [Sécurité opérationnelle][operational-security].

[application-firewall]: {% post_url platform/networking/public/2000-01-01-application-firewall %}
[connectivity]: {% post_url security/overview/2000-01-01-connectivity %}
[operational-security]: {% post_url security/overview/2000-01-01-operational-security %}
[private-networks]: {% post_url platform/networking/private/2000-01-01-concepts %}
[routing]: {% post_url platform/networking/public/2000-01-01-routing %}
