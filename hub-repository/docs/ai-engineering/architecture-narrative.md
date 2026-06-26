# AI-Native Development Architecture — Design Narrative

**Audience:** Engineers evaluating or replicating this setup.
**Purpose:** Describe the architecture as a portable pattern — what's distinctive, and how the pieces
compose. Tool names are kept light on purpose; the value is in the shape.

---

## Is it "hub-and-spoke"?

"Hub-and-spoke" is a serviceable shorthand, but it's imprecise. Textbook hub-and-spoke is a *routing*
topology: spokes communicate only by passing traffic through a central node at runtime. Nothing here
routes through the hub at runtime — each repository still builds, tests, and deploys on its own. What
the hub actually does is **aggregate capability**: the behaviors that steer the assistant are authored
in the repository they serve, then composed into a single launch context at the hub. The honest
framing is **a single control plane over a polyrepo** — *federated authoring, centralized composition
and governance*.

---

## Distinctive attributes (one paragraph each)

### 1. A control-plane hub over a polyrepo

The estate is many independent repositories, each with its own build system, branch model, review
process, and deployment pipeline. Rather than configure the assistant separately in each, every
engineer launches it from one designated repository (the hub), regardless of which project they're
editing. The hub is both the **single launch point** and the **governance root**: it holds the
canonical configuration and is itself a normal repo developed like any other. One coherent surface
over a fragmented estate — the assistant can read, edit, build, and open reviews across all repos in a
session, but there's exactly one place where "how the assistant behaves" is defined and reviewed.

### 2. Federated authoring, centralized composition

Capabilities are **owned where they're used** but **composed where they're launched**. A workflow that
only makes sense for one repository is authored and version-controlled *in that repository*, next to
the code it operates on, so its owners maintain it without reaching into the hub. A bootstrap routine
composes those scattered capabilities into the hub's configuration at setup time, applying a
**namespacing prefix** so provenance is legible at a glance. This is the inverse of a monorepo —
instead of centralizing the *code*, it centralizes only the *control surface* while leaving ownership
distributed.

### 3. A locally-built tool runtime per developer

The assistant's reach into live systems is delivered through small **tool servers** that each developer
runs **locally**, rather than calling shared hosted endpoints. Each is installed into an isolated
environment during setup and wired in through a **generated, gitignored manifest** rendered from a
**committed template** with the developer's identity substituted in — so the recipe is shared and
reviewable while resolved per-machine paths and credentials never enter version control. Two properties
make it safe by construction: servers launch **read-only by default**, and each is **scoped to a
specific environment** via a named credential profile, so a server pointed at a lower environment
physically cannot reach production.

### 4. Configuration as code: a small set of committed primitives

Everything that shapes behavior is one of a handful of **version-controlled primitives**, reviewed like
any other code: *skills* (reusable, invocable workflows), *rules* (guidance that loads contextually by
file path), *hooks* (scripts the harness runs automatically on lifecycle events), *subagents* (focused
specialists the assistant delegates to), and *settings* (permissions and wiring). Because these are
files in a repo rather than personal local preferences, behavior is **auditable, diffable, and shared**.
Rules load *on demand* by file-path pattern, so the assistant attends to a standard only while editing
the files it governs — keeping working context lean.

### 5. Lifecycle hooks as guardrails

A set of **event-triggered hooks** bracket the assistant's activity. At **session start**, a hook
reports each repository's state and emits time-aware warnings. **Before** a sensitive action it
validates the command (confirming repo-targeting, gating protected-branch pushes); **after** a file
edit it runs quick validators so mistakes surface immediately instead of at build time; and at
**session stop** it warns about uncommitted work the delivery flow would otherwise discard. These are
deterministic harness machinery, not advice the model may ignore — which is what lets the team rely on
them as guardrails.

### 6. Role-aware, least-privilege permissioning

The same configuration is **parameterized by role** at setup time. Different roles receive different
permission templates — one with full write access, another that makes infrastructure code read-only
while leaving application code editable — so the "may change" vs "may only read" boundary is enforced
by the harness rather than by individual diligence. The design assumes production until proven
otherwise and prefers a denied action over a risky one.

### 7. Reflexive self-governance

The configuration **maintains itself through itself.** A dedicated meta-skill is the sanctioned entry
point for changing any primitive, and it encodes the team's own standards — naming conventions,
required metadata, a cross-reference check that forces a fact stated in multiple places to be updated
everywhere at once, and a test-before-wire protocol for the riskiest primitive (hooks, because a bad
hook can block all work). A companion rule ensures any edit to configuration first loads those
standards. The control plane evolves with the same discipline it imposes on the code it governs.

### 8. Autonomous and scheduled operation

The same primitives support **unattended operation.** Several workflows are designed to run headless —
triaging incoming work, scanning reviews, checking health — and a scheduling layer can register them as
recurring jobs. Autonomous runs are deliberately scoped (for example, a triage routine that observes
and comments but takes no mutating action), so autonomy can be dialed up without surrendering the
safety boundaries the rest of the architecture enforces.

---

## How it all works together

A new engineer clones the repositories, launches the assistant once from the hub, and runs the
bootstrap routine. That routine reads their role, writes the matching permission template, renders the
tool-server manifest, installs each server locally, and composes the other repositories' capabilities
into the hub's control surface under provenance-revealing prefixes. From then on, every session opens
with a state check; contextual rules load only for the files in play; edits are validated as they're
written; sensitive commands are gated before they run; delivery is a single governed workflow across
whichever repos changed; and the session closes with a check that nothing was left behind. The estate
stays a polyrepo — distributed ownership, independent pipelines — but the engineer experiences one
assistant with one consistent, reviewed, role-appropriate behavior. The deepest idea is **reflexivity**:
the control plane is itself code, governed by the same review, validation, and rollback discipline it
applies to everything else.

---

## A design tradeoff worth calling out

Step 2 (composition) can be implemented two ways, and the choice has real consequences:

- **Symlink the capabilities up** — each contributed skill/rule stays single-sourced in its home repo;
  edits there are seen instantly by the hub, and there's no drift. But the link is a local artifact,
  invisible to the hub's committed history.
- **Vendor copies into the hub** — the hub gets full history and review of every capability, but the
  copies can silently **drift** from their source unless you add a sync/lint check.

Neither is wrong; pick deliberately. A healthy middle ground is to symlink for local composition *and*
run a periodic check that flags when a vendored copy has diverged from its origin.
