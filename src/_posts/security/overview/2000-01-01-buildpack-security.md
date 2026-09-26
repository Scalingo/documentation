---
title: Buildpack Security
nav: Buildpacks
modified_at: 2026-09-24 00:00:00
tags: compliance security measures buildpacks
index: 16
---

- [English version](#en)
- [Version française](#fr)

## English {#en}

### Buildpack Overview

Buildpacks transform application source code into an executable application. They detect the application's
programming language and install the dependencies it needs to run. See the
[Buildpacks documentation]({% post_url platform/deployment/buildpacks/2000-01-01-intro %}) for more details.

### Runtime Origin

The runtimes used by buildpacks come mainly from the open source community.

### Security Practices

Scalingo applies the necessary security checks and practices to buildpacks within its maintenance scope. These
practices include:

* Monitoring security advisories for the buildpacks in use
* Updating buildpacks to include available security fixes
* Testing new buildpacks and new versions before integration
* Checking the integrity of sources when downloading open source runtimes

Security updates for third-party buildpacks are handled on a best-effort basis. When a fix for a known
vulnerability is available, its integration is prioritized.

### Build and Runtime Lifecycle

A buildpack runs during the build phase of a deployment and contributes to the application image. The image is
then used to run the application. Files produced by a buildpack, such as dependencies, binaries, configuration,
or startup scripts, can remain in the final image and be used at runtime.

### Custom Buildpacks

Applications can use a [custom buildpack]({% post_url platform/deployment/buildpacks/2000-01-01-custom %}),
including buildpacks hosted by third parties or developed by customers. The practices described on this page do
not constitute a security assessment, review, or certification of custom buildpack code supplied or controlled
by a customer.

---

## Français {#fr}

### Aperçu des buildpacks {#apercu-des-buildpacks}

Les buildpacks transforment le code source d'une application en application exécutable. Ils détectent son langage
de programmation et installent les dépendances nécessaires à son exécution. Voir la
[documentation des buildpacks]({% post_url platform/deployment/buildpacks/2000-01-01-intro %}) pour plus de détails.

### Origine des runtimes {#origine-des-runtimes}

Les runtimes utilisés par les buildpacks proviennent principalement de la communauté open source.

### Pratiques de sécurité {#pratiques-de-securite}

Scalingo applique les vérifications de sécurité et les pratiques nécessaires aux buildpacks couverts par son
périmètre de maintenance. Cela comprend :

* la surveillance des alertes de sécurité concernant les buildpacks utilisés ;
* la mise à jour des buildpacks pour intégrer les correctifs de sécurité disponibles ;
* des tests lors de l'intégration de nouveaux buildpacks et de nouvelles versions ;
* la vérification de l'intégrité des sources lors du téléchargement de runtimes open source.

Les mises à jour de sécurité des buildpacks tiers sont traitées selon une approche best effort. Lorsqu'un
correctif est disponible pour une vulnérabilité connue, son intégration est prioritaire.

### Cycle de build et d'exécution {#cycle-de-build-et-d-execution}

Un buildpack s'exécute pendant la phase de build d'un déploiement et contribue à la production de l'image
applicative. Cette image sert ensuite à exécuter l'application. Les fichiers produits par un buildpack, comme
les dépendances, les binaires, la configuration ou les scripts de démarrage, peuvent rester dans l'image finale
et être utilisés à l'exécution.

### Buildpacks personnalisés {#buildpacks-personnalises}

Les applications peuvent utiliser un [buildpack personnalisé]({% post_url platform/deployment/buildpacks/2000-01-01-custom %}),
hébergé par un tiers ou développé par le client. Les pratiques décrites sur cette page ne constituent ni une
évaluation de sécurité, ni une revue, ni une certification du code d'un buildpack personnalisé fourni ou contrôlé
par un client.
