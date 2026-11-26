---
title: Getting access to SecNumCloud Region
nav: SecNumCloud
modified_at: 2026-11-25 00:00:00
tags: security procedures secnumcloud
---

The SecNumCloud region (`osc-secnum-fr1`) hosts resources such as applications
and databases. Scalingo approves access for a personal account or an
organization.

## Personal account

Approval covers your entire personal account, including when you first
request access to collaborate on a resource.

### Request access to host resources

#### Pre-conditions

- The application must be owned by a company or public body. Individual applicants are not eligible.
- The owning entity must be established in the European Union and maintain a physical presence in an EU member state.
- The application must have a legitimate need to be hosted in a SecNumCloud environment, whether for business, regulatory, or security reasons.

#### Procedure

1. Contact support using the standard means (email or chat)
2. Provide the following information
   - Project or application covered by the request
   - Street address of the company / entity
   - Reason of requesting the access
3. A first answer will be provided under 7 business days
4. _First-time domain or project registration only:_ an identity verification will be conducted.
Have the Identity Document of the new app owner ready or use official tools like [France Identité](https://france-identite.gouv.fr/justificatif/).
If the requester is not the owner, the owner will have to also contact directly the support.

Note: this identity verification will take place each time a new domain is added to the SecNumCloud region.

### Collaborate on SecNumCloud resources

Your personal account must first be allow-listed to access `osc-secnum-fr1`.

#### Pre-conditions

- The collaborator must have a legitimate reason to access the `osc-secnum-fr1` region, such as creating or collaborating on an application hosted there.
- The collaborator must act as an employee of a company, using a verified company email address (domain verification ensures that the organization controls the specified domain, allowing us to authenticate communications sent on its behalf).
- The company domain must already be associated with at least one existing application in the `osc-secnum-fr1` region, or be declared as owned by the organization.

#### Procedure

##### Access through an existing application

- If your company already hosts one or more applications in the `osc-secnum-fr1` region, the application owner can invite you directly as a collaborator.
- If your company domain is not yet allow-listed, you may ask the support team to register it. Once validated, everyone with an email address on that domain will be eligible to access the region without further access confirmation needed from the support.

##### Access without allow-listed domain

- If your company domain has not been declared or allow-listed, the request must still come from the application owner.
- The owner of the application must send the collaborator an invitation.
- The collaborator must contact the support using standard means (email or chat) to request access.
- The support team will need the owner to confirm the request before granting access.

##### Domain declaration and regularization

- To simplify future collaborator additions or removals, a company may request domain allow-listing (or submit a list of specific people) through the support channel (email or chat).
- The domain must already be associated with an existing Scalingo account or application; we do not pre-register unregistered domains from Scalingo services.

An answer will be provided within two business days.

## Organization

### Request access

Only an organization administrator can request access on behalf of an
organization. Contact Support by email or chat and include the following
information in the request.

- The organization making the request and its business or public-sector activity.
- How the organization plans to use SecNumCloud and why it needs the region.

Scalingo reviews your request and verifies your organization's identity and your
administrator role. Support will also ask you to verify your identity, provide
documents about the organization, or describe a project that illustrates your
intended use of SecNumCloud.

Once Scalingo approves and activates access for the organization, members with
permission to create projects can select the SecNumCloud region for new projects
in that organization.

### Collaborate on SecNumCloud resources

Members of an approved organization can be added as collaborators on its
SecNumCloud resources without separate SecNumCloud approval. Each member's
permissions determine which resources they can access.
