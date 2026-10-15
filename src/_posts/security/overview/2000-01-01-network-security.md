---
title: Network Security
nav: Network
modified_at: 2026-10-15 00:00:00
tags: compliance security measures
index: 2
---

- [English version](#en)
- [Version française](#fr)

## English {#en}

### Public application traffic

Scalingo routes public HTTP and HTTPS traffic to application `web` containers. The Application Firewall is in Preview
and available on request. It filters traffic by source IPv4 address for public HTTP/HTTPS requests to `web` containers.
TCP add-ons and Private Networks are unaffected, and the firewall does not inspect request content like a Web Application
Firewall. See the [Application Firewall][application-firewall] and [public routing][routing] documentation.

Scaling and autoscaling can add capacity, but cannot distinguish malicious traffic from a legitimate increase. Configure
application-specific protections in your application or through a suitable proxy or CDN.

For private application connectivity, see [Private Networks][private-networks] and [customer VPN
connectivity][connectivity]. Controls for staff access to platform administration are described in
[operational security][operational-security].

---

## Français {#fr}

### Trafic public vers les applications

Scalingo achemine le trafic HTTP et HTTPS public vers les conteneurs applicatifs `web`. Le pare-feu applicatif est en
préversion et accessible sur demande. Il filtre le trafic selon l'adresse IPv4 source pour les requêtes HTTP/HTTPS
publiques vers les conteneurs `web`. Les add-ons TCP et les réseaux privés ne sont pas concernés. Le pare-feu n'inspecte
pas le contenu des requêtes comme le ferait un pare-feu applicatif Web (WAF). Consultez les pages
[Pare-feu applicatif (en anglais)][application-firewall] et [routage public (en anglais)][routing].

La mise à l'échelle et l'autoscaling peuvent augmenter la capacité, mais ne distinguent pas le trafic malveillant d'une hausse
légitime. Configurez les protections propres à votre application ou utilisez un proxy ou un CDN adapté.

Pour la connectivité privée des applications, consultez les pages [Réseaux privés (en anglais)][private-networks] et
[connectivité VPN client (en anglais)][connectivity]. Les contrôles d'accès du personnel à l'administration de la
plateforme sont décrits dans la page [Sécurité opérationnelle][operational-security].

[application-firewall]: {% post_url platform/networking/public/2000-01-01-application-firewall %}
[connectivity]: {% post_url security/overview/2000-01-01-connectivity %}
[operational-security]: {% post_url security/overview/2000-01-01-operational-security %}
[private-networks]: {% post_url platform/networking/private/2000-01-01-concepts %}
[routing]: {% post_url platform/networking/public/2000-01-01-routing %}
