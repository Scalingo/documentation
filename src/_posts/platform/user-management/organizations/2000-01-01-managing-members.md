---
title: Managing Members
modified_at: 2026-11-13 00:00:00
tags: organization member invitation administrator
index: 3
---

Members with the **Admin** role can invite users and remove members from the
organization's **Members** page. Each invited user must accept the invitation to
become a member.

Joining an organization does not grant access to its resources.
[Add each member as a collaborator on each resource they need][collaborators].

## Inviting a Member

1. Open your [Dashboard][dashboard].
2. Select the organization you want to manage.
3. Open **Members**.
4. Click **Invite a member**.
5. Enter the person's email address.
6. Click **Send invitation**.

Scalingo sends an invitation to that address and lists it under **Pending
invitations**. The user has **7 days** to accept it.

You can invite someone who does not have a Scalingo account. Learn more about the
[invitation process][invitation].

## Viewing Members and Invitations

1. Open your [Dashboard][dashboard].
2. [Select the organization][organization-context].
3. Open **Members**.

The page shows:

- **Members**: Each member's username, email address, organization role, 2FA status
  and last activity.
- **Pending invitations**: The invited email address, when the invitation was sent,
  who sent it and whether it has expired.


## Accepting an Invitation

If you have received an invitation to join an organization, follow these steps
to become a member:

1. Open the organization invitation email and click **Accept invitation**.
2. Sign in with the Scalingo account whose email address matches the invitation.
   If you do not have an account, create one with that email address, then reopen
   the invitation email and follow its link again.

If you are signed in with a different email address, sign out and sign in with the
account that received the invitation.

Once you accept the invitation, you become a member and can select the
[organization in the Dashboard][organization-context]. You can then
[ask for access to the resources you need][resource-access].

{% note %}
You cannot accept an expired or cancelled invitation. Ask the organization's
administrator for a new one.
{% endnote %}

## Invitation States and Actions

| State | Effect | Administrator action |
| ----- | ------ | -------------------- |
| Pending | The user has not accepted the invitation yet. | Cancel the invitation with **Cancel invitation**. |
| Accepted | The new member can select the organization in the Dashboard. | [Add the member as a collaborator on each resource they need][collaborators]. |
| Expired | After 7 days, the user can no longer accept the invitation. You can still view it for 30 days after expiration. | Use **Delete invitation**, then send a new invitation. |
| Cancelled | The user can no longer accept the invitation. | Send a new invitation if the person should still join. |

Cancelling a pending invitation takes effect immediately. You can send a new
invitation at any time.

## Removing a Member

Removing a member immediately revokes their access to the organization and all
its projects and resources, including applications and databases. You do not need
to revoke their collaborator access on each resource separately.

To remove a member, you must have the **Admin** role:

1. Open your [Dashboard][dashboard].
2. [Select the organization][organization-context] and open **Members**.
3. Find the member you want to remove.
4. Open the **…** menu on their row and select **Remove member**.
5. Check the member and organization in the confirmation window, then click
   **Remove member**.

{% note %}
To remove access to a single resource instead, revoke collaborator access on that
resource. The person remains a member of the organization and keeps their access
to other resources.
{% endnote %}

{% note %}
Removing a member does not change credentials they may already know. Rotate any
passwords, API tokens or other secrets they could use to access your resources
directly.
{% endnote %}

[dashboard]: https://dashboard.scalingo.com/
[collaborators]: {% post_url platform/user-management/organizations/2000-01-01-overview %}#members-and-resource-access
[invitation]: #accepting-an-invitation
[organization-context]: {% post_url platform/user-management/organizations/2000-01-01-overview %}#accessing-an-organization-in-the-dashboard
[resource-access]: {% post_url platform/user-management/organizations/2000-01-01-overview %}#members-and-resource-access
