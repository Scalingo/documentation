---
title: Network Security
nav: Network
modified_at: 2026-04-16 00:00:00
tags: compliance security measures
index: 2
---

- [English version](#en)
- [Version française](#fr)

<a id="en"></a>

## English

### DDoS Protection

We use a multi-level approach to protect the platform from DDoS attacks:

- data scrubbing centers are used to filter out malicious traffic (Region `osc-secnum-fr1`)
- we implement IP filtering based on known malicious IP addresses lists that are regularly updated
- we use rate limiting to prevent excessive traffic from overwhelming the platform
- we have deployed an adequate number of servers to handle the expected traffic volume

The last level of protection is your application, as your code should be able to handle the traffic it receives. We have
no means of distinguishing between an attack and a sudden increase in legitimate traffic.

If your application is not able to withstand the traffic it receives, we encourage you to subscribe to a CDN service
that will help you absorb the traffic and distribute it across multiple servers.

### Network isolation

Our network is isolated from the public internet to prevent unauthorized access to the platform. Inside the network, we
use VLANs to separate different parts of the platform and to prevent unauthorized access between them.

### Firewalls

Scalingo uses firewalls to protect the platform from unauthorized access. The firewalls are configured to allow only the
necessary traffic and to block all other traffic. There are multiple layers of firewalls to protect the platform from
different types of attacks. Inside the network, we use firewalls to protect the different parts of the platform from
each other.

### VPN

Our operations team uses VPNs to access the platform securely. This ensures that all access to the platform is encrypted
and secure.

---

<a id="fr"></a>

## Français

### Protection DDoS

Nous utilisons une approche multi-niveaux pour protéger la plateforme contre les attaques DDoS :

- des centres de nettoyage de données sont utilisés pour filtrer le trafic malveillant (Région `osc-secnum-fr1`)
- nous implémentons un filtrage IP basé sur des listes d'adresses IP malveillantes connues qui sont régulièrement mises à jour
- nous utilisons la limitation de débit pour empêcher un trafic excessif de submerger la plateforme
- nous avons déployé un nombre adéquat de serveurs pour gérer le volume de trafic attendu

Le dernier niveau de protection est votre application, car votre code doit être capable de gérer le trafic qu'il reçoit. Nous n'avons aucun moyen de distinguer entre une attaque et une augmentation soudaine du trafic légitime.

Si votre application n'est pas capable de résister au trafic qu'elle reçoit, nous vous encourageons à souscrire à un service CDN qui vous aidera à absorber le trafic et à le distribuer sur plusieurs serveurs.

### Isolation Réseau

Notre réseau est isolé de l'internet public pour empêcher les accès non autorisés à la plateforme. À l'intérieur du réseau, nous utilisons des VLAN pour séparer les différentes parties de la plateforme et pour empêcher les accès non autorisés entre elles.

### Pare-feu

Scalingo utilise des pare-feu pour protéger la plateforme contre les accès non autorisés. Les pare-feu sont configurés pour autoriser uniquement le trafic nécessaire et bloquer tout autre trafic. Il existe plusieurs couches de pare-feu pour protéger la plateforme contre différents types d'attaques. À l'intérieur du réseau, nous utilisons des pare-feu pour protéger les différentes parties de la plateforme les unes des autres.

### VPN

Notre équipe d'exploitation utilise des VPN pour accéder à la plateforme de manière sécurisée. Cela garantit que tous les accès à la plateforme sont chiffrés et sécurisés.
