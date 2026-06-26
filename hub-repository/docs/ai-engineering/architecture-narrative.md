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

## Everyone starts from one place

Most teams work across many separate repositories, each with its own build, tests, and release
process. If the assistant were configured separately inside each repository, the team would maintain
the same setup many times and still end up with differences between them. Instead the team chooses one
repository as the place to start the assistant, and always launches it from there. This repository is
called the hub. You start from the hub whether the work ahead is in the hub or in another repository.
The assistant can still open, read, and change files in every other repository. What stays fixed is
where it reads its own instructions from. The benefit is consistency and low maintenance. Every
engineer gets the same behavior because it comes from the same reviewed source, and there is only one
configuration to keep current instead of one for each repository.

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

## Each repository teaches the assistant about itself

The instructions for working in a repository live inside that repository, beside the code they
describe. The Python service holds its Python conventions. The infrastructure repository holds its
infrastructure rules. When an engineer sets up their machine, a setup step collects those instructions
from every repository and makes them available from the hub, with a label showing which repository each
one came from. This keeps responsibility where it should be. The people who own a repository keep its
assistant instructions correct on their own, and they do not have to ask the hub's owner to make a
change. The engineer still gets a single, combined set of capabilities when they launch.

## Safety happens at fixed moments, on its own

A few checks run by themselves at set points during a session. One runs at the start and reports the
true state of every repository, such as which branch it is on and whether it has unsaved work. One runs
before a command and can stop an action that is risky or aimed at the wrong place before it happens.
One runs after a file is edited and points out a problem right away instead of leaving it for the
build. One runs at the end and warns about work that was never saved. These are plain scripts, and the
tool runs them rather than the assistant, so they cannot be forgotten or skipped. This is what makes
the setup trustworthy. The team does not depend on the model to remember a rule, because the important
rules are applied by the tool every time.

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
else. So the system that brings order to the team's work is kept in order the same way the work is.
This is what stops the setup from slowly falling into inconsistency as more people add to it over time.

## How it comes together

An engineer clones the repositories, starts the assistant once from the hub, and runs the setup step.
From then on each session begins by reporting the real state of the work, loads only the rules that fit
the files in play, checks edits as they are made, stops unsafe commands before they run, delivers
finished work through one reviewed workflow, and closes by pointing out anything left unsaved. The
repositories stay independent, with their own builds and their own releases, but the person sees one
assistant that behaves the same way every time, for everyone.

## One decision worth making on purpose

Collecting each repository's instructions into the hub can be done two ways, and it is worth choosing
deliberately. You can link to them, so each instruction still has one true copy in its home repository
and an edit there is seen immediately, though the link itself only exists on a developer's machine. Or
you can copy them into the hub, so the hub keeps a full history of every instruction, though the copies
can fall out of step with the originals unless you add a check that compares them. Neither is wrong. A
reasonable middle path is to link them for everyday use and run a periodic check that flags any copy
that has drifted from its original.
