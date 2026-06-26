# The Day-to-Day Development Cycle

This describes what working day to day actually looks like for an engineer on a team that runs this
setup. The earlier documents explain the design. This one is the lived experience.

## Starting the day

An engineer does not navigate to a folder and remember a launch command. They type one short word.

During first-time setup they add a small shortcut to their shell, named something like `dev`, that
moves into the hub repository and starts the assistant there. The name does not matter. The habit does.
From that point on, starting work is a single word, and it always begins in the same place. Because the
assistant always starts from the hub, it always starts with the same reviewed configuration, no matter
which project the day's work is in.

## What happens the moment a session begins

Before the engineer types anything, the session has already prepared itself. A check runs automatically
at startup and does two things. First, it pulls the latest version of the repositories, so the newest
shared skills and rules are present from the very first message. An improvement someone merged
yesterday is simply there today, with nothing to install. Second, it reports the real state of the
work: which branch each repository is on, whether anything is unsaved, whether the team has agreed not
to release today. The engineer starts already oriented, rather than discovering a surprise halfway
through.

## Starting a piece of work as a project

Larger work is treated as a small project with its own folder, and it follows a rhythm of research,
then planning, then supervised execution.

The engineer makes a folder for the work under the documentation area, with a place for research and a
place for plans. They ask the assistant to research the problem, and it writes up what it finds in the
research folder: how the relevant code works today, what will have to change, what the risks are. The
engineer reads it and corrects course while the cost of changing direction is still low.

With the research settled, they ask the assistant to break the work into phases and write a separate
prompt for each phase, saved in the plans folder. Each prompt is a self-contained instruction for one
slice of the work. This matters because one enormous instruction tends to wander, while a sequence of
focused ones stays on track and gives the engineer a natural checkpoint between each.

Then they execute the phases one at a time, watching the work as it happens. The engineer stays in the
loop, approving as they go. The writing of the plan and the doing of the work are kept separate on
purpose, so that thinking is finished before building starts.

## Writing, testing, and delivering a change

The ordinary cycle of writing code, testing it, and shipping it is itself a saved workflow, so it
happens the same way every time.

When a change is ready, the engineer asks the assistant to deliver it, and a single skill carries the
whole sequence. It builds the code and runs the tests, and it will not proceed if they fail. It commits
the change to the right repository, since each repository is delivered on its own. It opens a review
for that change. When a reviewer leaves comments, the assistant can read them, make the small fixes,
and respond, so the back-and-forth of getting a review approved is handled in the same place as the
work. The engineer is delivering work, not remembering the steps of delivery.

## Working from tickets

Much of the work starts as a ticket, and the assistant can work directly from the team's tracker.

A skill can read a ticket, do the work it describes, and update the ticket as it goes, leaving notes and
moving it along. The engineer does not copy details out of the tracker by hand or back into it
afterward. The system of record stays current as a side effect of doing the work.

## When the assistant gets something wrong

The assistant will sometimes behave in a way an engineer does not like. The point of this setup is that
the fix is shared, not personal.

Rather than working around the problem alone, the engineer uses the skill whose job is to improve the
configuration. They describe what should change, and the improvement is made the proper way and goes
through review, so that once it is accepted the whole team has the better behavior. A single person's
annoyance becomes a durable fix for everyone. This is how the setup gets better over time instead of
each person quietly compensating in private.

## Where a piece of knowledge belongs

As the assistant is used, the engineer keeps learning things worth holding onto, and there are three
homes for that knowledge. Choosing the right one is most of the skill.

A fact that matters only to one person belongs in that person's private memory. A preference for how
someone likes their own summaries written has no reason to live in the shared setup.

A fact about a project that the whole team should rely on belongs in that project's standing context or
in a rule, in version control. How a particular service is built, or a convention everyone should
follow, is shared knowledge and is reviewed like anything else.

A change to how the assistant itself behaves belongs in the configuration, through the improvement
skill. This is for new abilities or changed behavior, not mere facts.

The test is simple. Ask who else needs this. If the answer is only me, it is personal memory. If the
answer is the team, it is shared context. If it changes what the assistant can do, it is the
configuration.

## Getting set up the first time

All of this rests on a one-time setup that a new engineer runs once.

They clone the repositories, start the assistant from the hub, and run the setup step. That step
prepares their machine: it gives them the access their role calls for, it connects the tools the
assistant uses to read live information, and it gathers every repository's instructions into the hub so
they are available from the one starting point. After that, the daily rhythm takes over, and the
startup check keeps each session current on its own. Setup is a one-time cost. Staying current is free,
and automatic.
