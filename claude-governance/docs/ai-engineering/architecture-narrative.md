# How the Architecture Works

This explains the ideas behind the setup in plain terms, and why each one earns its place. The
repository it lives in is an illustration, so the names are invented, but the ideas are the real ones.

## The problem it solves

A team that adopts an AI coding assistant tends to recreate an old problem. Each person sets the
assistant up on their own machine, in their own way. Everyone teaches it the same things about the
codebase over and over. Behavior drifts from one person to the next, and there is no safety net,
because every safeguard depends on someone remembering to be careful. Teams solved this for ordinary
code a long time ago. They put shared practice into version control and reviewed changes to it. This
architecture does the same thing for the assistant. The single idea underneath all of it is that the
assistant's configuration is code. It lives in version control, it is reviewed, and it is shared.
Everything that follows is a consequence of taking that one idea seriously.

## The configuration is ordinary files, kept next to the code

Everything that tells the assistant how to behave is a plain file in version control. There are a few
kinds, each with a clear job. Some files give the assistant standing context about a project that it
reads every time. Some are rules that apply only when it works on particular files, so the guidance for
writing database queries shows up while it edits a query and stays quiet otherwise. Some are saved
workflows, which the team calls skills, that carry out a task with many steps, such as delivering a
change or working through an alert. Some are small specialists that the assistant can hand a narrow job
to. And some are checks that run automatically at set moments. Keeping all of this in version control
has a plain payoff. A change to how the assistant works is proposed and reviewed like any other change,
and once it is accepted everyone has it the next time they start. None of it is hidden on a single
person's machine.

## Shared capability travels as a plugin

The skills, rules, checks, and specialists that the whole team relies on live in one repository whose
only job is to hold them. From there they are packaged as a plugin. Each developer enables that plugin
once, and from then on every session has the team's shared capability, no matter which repository the
work is in. When the team improves something, they release a new version of the plugin and everyone
picks it up. There is no copying files between repositories and no fragile web of links to maintain, so
nothing drifts out of step. The repository that holds the plugin is authored and reviewed carefully; it
is not a place anyone works from day to day.

## Each repository teaches the assistant about itself

The instructions for working in a single repository live inside that repository, beside the code they
describe. The Python service holds its Python conventions. The infrastructure repository holds its
infrastructure rules. Alongside those, each repository states a few plain facts about itself in a small
file: how it is built, how it is deployed, what it depends on. The assistant reads those facts rather
than having them hard-coded somewhere central. This keeps responsibility where it should be. The people
who own a repository keep its instructions and its facts correct on their own, and the shared plugin
stays general, because the specifics live with each repository instead of inside the shared parts.

## One map of the whole estate

There is a small amount of knowledge that does not belong to any single repository and cannot be
packaged into a general plugin either, because it is specific to this team: the list of every
repository, what each one does, where a push to it actually deploys, which credentials reach which
environment, and how the repositories depend on one another. This is gathered into one map. Each
repository contributes its own row of facts, and the map is the assembled whole. The assistant reads it
to answer three everyday questions: which repository holds the thing I need to change, which set of
repositories a single piece of work will touch, and what the safety meaning of an action is in a given
repository. This map is the one piece that genuinely needs a single home, and it lives in the same
reviewed repository as the shared plugin.

## Developers work from one neutral place

Most real changes touch several repositories, and there is usually no single "right" one to start from.
So developers begin every session from a separate repository whose job is to be the starting point. It
is neutral ground, not any one product's code. Starting work is a single habit, from one place, with
the same shared capability every time. When a session begins, a check pulls the latest shared
governance, loads the estate map, and reports the real state of the repositories in play, so the
assistant is oriented before anyone types. From this starting point it can open, read, and change files
in any repository the work requires.

## Work lives as a project, in a known place

Because that starting-point repository is fixed and shared, it is also where multi-step work is kept, so
the work itself does not scatter. Each project gets a folder with its research, its plan broken into
phases, and a running log of what has happened. The research is done first and written down. Then the
work is broken into phases, each a self-contained instruction, so a long effort stays on track and has
natural checkpoints. The durable record of a cross-repository effort lives in that folder, not in a
single session's memory, so anyone can find a project, see where it stands, and pick it up. This is also
what guards against narrow, one-repository fixes when an elegant solution needs to span several: the
plan holds the whole picture on purpose.

## Safety happens at fixed moments, on its own

A few checks run by themselves at set points during a session. One runs at the start and orients the
session. One runs before a command and can stop an action that is risky or aimed at the wrong place
before it happens. One runs after a file is edited and points out a problem right away instead of
leaving it for the build. One runs at the end and warns about work that was never saved. These are plain
scripts, and the tool runs them rather than the assistant, so they cannot be forgotten or skipped. This
is what makes the setup trustworthy. The team does not depend on the model to remember a rule, because
the important rules are applied by the tool every time. The general checks travel in the shared plugin;
the one that needs estate-wide knowledge reads the map rather than carrying its own copy of the facts.

## People get the access their role calls for

Not everyone should be able to change everything. The same configuration can be handed to the whole
team while still giving each person the access their role calls for, so that someone who should not
alter infrastructure cannot do so, while still reading all of it and changing everything else they work
on. The line between what a person may change and what they may only read is held by the tool, not by
individual caution.

## The assistant improves its own setup, under the same rules

Sooner or later the configuration itself needs to change. There is one proper way to do that. A
dedicated skill exists whose only purpose is to edit the configuration correctly. It knows the team's
conventions, applies them, and the change still goes through normal review before it reaches anyone
else, then ships as a new version of the shared plugin. So the system that brings order to the team's
work is kept in order the same way the work is. This is what stops the setup from slowly falling into
inconsistency as more people add to it over time.

## How it comes together

An engineer clones the repositories, starts the assistant from the neutral starting-point repository,
and runs a one-time setup that enables the shared plugin and connects the tools the assistant uses. From
then on each session begins by pulling the latest shared governance, loading the estate map, and
reporting the real state of the work. The assistant uses the map to work out which repositories a task
touches, loads only the rules that fit the files in play, checks edits as they are made, stops unsafe
commands before they run, delivers finished work through one reviewed workflow, and closes by pointing
out anything left unsaved. The repositories stay independent, with their own builds and their own
releases, but the person sees one assistant that behaves the same way every time, for everyone.

## Why two special repositories, not one

It is worth being clear about why the shared capability and the starting point are separate
repositories rather than a single combined one. They have different jobs. The governance repository is
authored and reviewed with care and changes rarely; you would not want people doing daily work inside
it. The starting-point repository is lived in every day and fills up with project folders and running
notes; you would not want the team's reviewed capability mixed into that churn. Splitting them keeps the
shared parts stable and versioned while the daily workspace stays focused on getting work done. The only
knowledge that must sit in one central place is the estate map, and it lives with the governance
repository where it can be reviewed. Everything else is either shared through the plugin or kept in the
repository it belongs to.
